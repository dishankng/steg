cover=imread('sunflower.jpg');
message=imread('main.bmp');
coverSize=size(cover);
messageSize=size(message);

figure;
image(cover); % original(cover image)
title('Original(cover image)');

figure;
image(message); % message image to be hidden
title('message image to be hidden');

newcover=cover; 

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

origIndI=indI;
origIndJ=indJ;

count=0;% To be changed to a better method; % no. of pixels of cover image used
i=1;j=1;

for x=1:messageSize(1)
    for y=1:messageSize(2)
        for colInd=1:3
            message8=message(x,y,colInd); % 8bits of message
            
            % pixel of cover Image is split into group A and group B. A-top
            % B- bottom group
            pixelA = 4*bitget(newcover(i,j,1),3) + 2*bitget(newcover(i,j,1),2) + 1*bitget(newcover(i,j,1),1) + 1*bitget(newcover(i,j,2),1);
            
            pixelB = 4*bitget(newcover(i,j,2),3) + 2*bitget(newcover(i,j,2),2) + 2*bitget(newcover(i,j,3),2) + 1*bitget(newcover(i,j,3),1);
            
            % Note- Weightage of pixelA is 8 and weightage of pixelB is 9
            
            %case 1- messageLeft in pixelA, messageRight in pixelB
            messageLeft = 4*bitget(message8,8) + 2*bitget(message8,7) + 1*bitget(message8,6) + 1*bitget(message8,5);
            messageRight= 4*bitget(message8,4) + 2*bitget(message8,3) + 2*bitget(message8,2) + 1*bitget(message8,1);
            
            if pixelA>=messageLeft
                value1=pixelA-messageLeft;
            else
                value1=messageLeft-pixelA;
            end
            if pixelB>=messageRight
                value2=pixelB-messageRight;
            else
                value2=messageRight-pixelB;
            end
            
            error1=8*(value1)+9*(value2);
            %error1=value1+value2;
            %case 2- messageLeft in pixelB, messageRight in pixelA
            messageLeft = 4*bitget(message8,8) + 2*bitget(message8,7) + 2*bitget(message8,6) + 1*bitget(message8,5);
            messageRight= 4*bitget(message8,4) + 2*bitget(message8,3) + 1*bitget(message8,2) + 1*bitget(message8,1);
            
            if pixelB>=messageLeft
                value1=pixelB-messageLeft;
            else
                value1=messageLeft-pixelB;
            end
            if pixelA>=messageRight
                value2=pixelA-messageRight;
            else
                value2=messageRight-pixelA;
            end
            
            error2=9*(value1)+8*(value2);
            %error2=value1+value2;
            if error1<=error2 %then put messageLeft in pixelA and messageRight in pixelB
                newcover(i,j,1)=bitset(newcover(i,j,1),3,bitget(message8,8));
                newcover(i,j,1)=bitset(newcover(i,j,1),2,bitget(message8,7));
                newcover(i,j,1)=bitset(newcover(i,j,1),1,bitget(message8,6));
                newcover(i,j,2)=bitset(newcover(i,j,2),1,bitget(message8,5));
                
                newcover(i,j,2)=bitset(newcover(i,j,2),3,bitget(message8,4));
                newcover(i,j,2)=bitset(newcover(i,j,2),2,bitget(message8,3));
                newcover(i,j,3)=bitset(newcover(i,j,3),2,bitget(message8,2));
                newcover(i,j,3)=bitset(newcover(i,j,3),1,bitget(message8,1));
                
                newcover(indI,indJ,colInd)=bitset(newcover(indI,indJ,colInd),1,0);
            else %then put messageLeft in pixelB and messageRight in pixelA
                newcover(i,j,2)=bitset(newcover(i,j,2),3,bitget(message8,8));
                newcover(i,j,2)=bitset(newcover(i,j,2),2,bitget(message8,7));
                newcover(i,j,3)=bitset(newcover(i,j,3),2,bitget(message8,6));
                newcover(i,j,3)=bitset(newcover(i,j,3),1,bitget(message8,5));
                
                newcover(i,j,1)=bitset(newcover(i,j,1),3,bitget(message8,4));
                newcover(i,j,1)=bitset(newcover(i,j,1),2,bitget(message8,3));
                newcover(i,j,1)=bitset(newcover(i,j,1),1,bitget(message8,2));
                newcover(i,j,2)=bitset(newcover(i,j,2),1,bitget(message8,1));
                
                newcover(indI,indJ,colInd)=bitset(newcover(indI,indJ,colInd),1,1);
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

figure;
image(newcover); % Cover image after image is hidden
title('Cover image after image is hidden');

% Now Data retreival
newimage=zeros(messageSize(1),messageSize(2),3,'uint8');

x=1;y=1;colInd=1;
indI=origIndI;
indJ=origIndJ;

for i=1:coverSize(1)
    for j=1:coverSize(2)
        if bitget(newcover(indI,indJ,colInd),1)==0
            %Then put pixelA in messageLeft and pixelB in messageRight 
            newimage(x,y,colInd)=bitset(newimage(x,y,colInd),8,bitget(newcover(i,j,1),3));
            newimage(x,y,colInd)=bitset(newimage(x,y,colInd),7,bitget(newcover(i,j,1),2));
            newimage(x,y,colInd)=bitset(newimage(x,y,colInd),6,bitget(newcover(i,j,1),1));
            newimage(x,y,colInd)=bitset(newimage(x,y,colInd),5,bitget(newcover(i,j,2),1));
            
            newimage(x,y,colInd)=bitset(newimage(x,y,colInd),4,bitget(newcover(i,j,2),3));
            newimage(x,y,colInd)=bitset(newimage(x,y,colInd),3,bitget(newcover(i,j,2),2));
            newimage(x,y,colInd)=bitset(newimage(x,y,colInd),2,bitget(newcover(i,j,3),2));
            newimage(x,y,colInd)=bitset(newimage(x,y,colInd),1,bitget(newcover(i,j,3),1));
            
        else
            %Put pixelB in messageLeft and pixelA in messageRight 
            newimage(x,y,colInd)=bitset(newimage(x,y,colInd),8,bitget(newcover(i,j,2),3));
            newimage(x,y,colInd)=bitset(newimage(x,y,colInd),7,bitget(newcover(i,j,2),2));
            newimage(x,y,colInd)=bitset(newimage(x,y,colInd),6,bitget(newcover(i,j,3),2));
            newimage(x,y,colInd)=bitset(newimage(x,y,colInd),5,bitget(newcover(i,j,3),1));
            
            newimage(x,y,colInd)=bitset(newimage(x,y,colInd),4,bitget(newcover(i,j,1),3));
            newimage(x,y,colInd)=bitset(newimage(x,y,colInd),3,bitget(newcover(i,j,1),2));
            newimage(x,y,colInd)=bitset(newimage(x,y,colInd),2,bitget(newcover(i,j,1),1));
            newimage(x,y,colInd)=bitset(newimage(x,y,colInd),1,bitget(newcover(i,j,2),1));
        end
        if colInd<3
            colInd=colInd+1;
        else
            colInd=1;
            if y<messageSize(2);
                y=y+1;
            else
                x=x+1;
                y=1;
            end
            if indJ<coverSize(2);
                indJ=indJ+1;
            else
                indI=indI+1;
                indJ=1;
            end
        end
        count=count-1;
        if count==0
            break
        end
    end
    if count==0
        break
    end
end

figure;
image(newimage);
title('Retreived image');
psnr = PSNR(newcover, cover);