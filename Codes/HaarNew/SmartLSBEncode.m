function [ stegoImage, count, messageSize, psnr ] = SmartLSBEncode( cover, messageImage )
%SMARTLSBENCODE Summary of this function goes here
%   Detailed explanation goes here

message=imread(messageImage);
coverSize=size(cover);
messageSize=size(message);


stegoImage=cover; 

%Now I will calculate the coordinates of the pixels from which to store the
%bits
% Note- x(i) is vertical, y(j) is horizontal
indI=(messageSize(1)*messageSize(2)*3)/coverSize(2); % The result will be in decimals
indI=ceil(indI);

indJ=mod((messageSize(1)*messageSize(2)*3),coverSize(2));

if indJ<coverSize(2)
    indJ=indJ+1;
else
    indI=indI+1;
    indJ=1;
end

%origIndI=indI;
%origIndJ=indJ;

count=0;% To be changed to a better method; % no. of pixels of cover image used
i=1;j=1;

for x=1:messageSize(1)
    for y=1:messageSize(2)
        for colInd=1:3
            message8=message(x,y,colInd); % 8bits of message
            
            % pixel of cover Image is split into group A and group B. A-top
            % B- bottom group
            pixelA = int16(4*bitget(stegoImage(i,j,1),3) + 2*bitget(stegoImage(i,j,1),2) + 1*bitget(stegoImage(i,j,1),1) + 1*bitget(stegoImage(i,j,2),1));
            
            pixelB = int16(4*bitget(stegoImage(i,j,2),3) + 2*bitget(stegoImage(i,j,2),2) + 2*bitget(stegoImage(i,j,3),2) + 1*bitget(stegoImage(i,j,3),1));
            
            % Note- Weightage of pixelA is 8 and weightage of pixelB is 9
            
            %case 1- messageLeft in pixelA, messageRight in pixelB
            messageLeft = int16(4*bitget(message8,8) + 2*bitget(message8,7) + 1*bitget(message8,6) + 1*bitget(message8,5));
            messageRight= int16(4*bitget(message8,4) + 2*bitget(message8,3) + 2*bitget(message8,2) + 1*bitget(message8,1));
            
           
                value1=abs(pixelA-messageLeft);
           
                value2=abs(pixelB-messageRight);
            
            error1=8*(value1)+9*(value2);
            %error1=value1+value2;
            %case 2- messageLeft in pixelB, messageRight in pixelA
            messageLeft = int16(4*bitget(message8,8) + 2*bitget(message8,7) + 2*bitget(message8,6) + 1*bitget(message8,5));
            messageRight= int16(4*bitget(message8,4) + 2*bitget(message8,3) + 1*bitget(message8,2) + 1*bitget(message8,1));
            
                value1=abs(pixelB-messageLeft);
                value2=abs(pixelA-messageRight);
            
            error2=9*(value1)+8*(value2);
            %error2=value1+value2;
            if error1<=error2 %then put messageLeft in pixelA and messageRight in pixelB
                stegoImage(i,j,1)=bitset(stegoImage(i,j,1),3,bitget(message8,8));
                stegoImage(i,j,1)=bitset(stegoImage(i,j,1),2,bitget(message8,7));
                stegoImage(i,j,1)=bitset(stegoImage(i,j,1),1,bitget(message8,6));
                stegoImage(i,j,2)=bitset(stegoImage(i,j,2),1,bitget(message8,5));
                
                stegoImage(i,j,2)=bitset(stegoImage(i,j,2),3,bitget(message8,4));
                stegoImage(i,j,2)=bitset(stegoImage(i,j,2),2,bitget(message8,3));
                stegoImage(i,j,3)=bitset(stegoImage(i,j,3),2,bitget(message8,2));
                stegoImage(i,j,3)=bitset(stegoImage(i,j,3),1,bitget(message8,1));
                
                stegoImage(indI,indJ,colInd)=bitset(stegoImage(indI,indJ,colInd),1,0);
            else %then put messageLeft in pixelB and messageRight in pixelA
                stegoImage(i,j,2)=bitset(stegoImage(i,j,2),3,bitget(message8,8));
                stegoImage(i,j,2)=bitset(stegoImage(i,j,2),2,bitget(message8,7));
                stegoImage(i,j,3)=bitset(stegoImage(i,j,3),2,bitget(message8,6));
                stegoImage(i,j,3)=bitset(stegoImage(i,j,3),1,bitget(message8,5));
                
                stegoImage(i,j,1)=bitset(stegoImage(i,j,1),3,bitget(message8,4));
                stegoImage(i,j,1)=bitset(stegoImage(i,j,1),2,bitget(message8,3));
                stegoImage(i,j,1)=bitset(stegoImage(i,j,1),1,bitget(message8,2));
                stegoImage(i,j,2)=bitset(stegoImage(i,j,2),1,bitget(message8,1));
                
                stegoImage(indI,indJ,colInd)=bitset(stegoImage(indI,indJ,colInd),1,1);
            end
            if j<coverSize(2)
                j=j+1;
            else
                i=i+1;
                j=1;
            end
            if colInd==3
                if indJ<coverSize(2)
                    indJ=indJ+1;
                else
                    indI=indI+1;
                    indJ=1;
                end
            end
            count=count+1;
        end
    end
end
psnr = PSNR(cover, stegoImage);
end