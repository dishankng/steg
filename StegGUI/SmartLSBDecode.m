function [ retrievedMessage ] = SmartLSBDecode( count, stegoImage, messageSize )
%SMARTLSBDECODE Summary of this function goes here
%   Detailed explanation goes here
coverSize = size(stegoImage);
newcover = stegoImage;

newimage=zeros(messageSize(1),messageSize(2),3,'uint8');

x=1;y=1;colInd=1;
indI=(messageSize(1)*messageSize(2)*3)/coverSize(2); % The result will be in decimals
indI=ceil(indI);

indJ=mod((messageSize(1)*messageSize(2)*3),coverSize(2));

if indJ<coverSize(2)
    indJ=indJ+1;
else
    indI=indI+1;
    indJ=1;
end


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
retrievedMessage = newimage;


end

