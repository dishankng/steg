function [ retrievedMessage ] = LSBDecode( count, stegoImage, messageSize )
%LSBDECODE Summary of this function goes here
%   Detailed explanation goes here
newimage=zeros(messageSize(1),messageSize(2),3,'uint8');
coverSize = size(stegoImage)
newcover = stegoImage
% Or, a = zeros(size(I),class(I));

x=1;y=1; %newimage
i=1;j=1;
n=1;

for i=1:coverSize(1)
    for j=1:coverSize(2)
        for it=3:-1:1
            newimage(x,y,n)=bitset(newimage(x,y,n),it+5,bitget(newcover(i,j,1),it));
        end
        for it=3:-1:1
            newimage(x,y,n)=bitset(newimage(x,y,n),it+2,bitget(newcover(i,j,2),it));
        end
        for it=2:-1:1
            newimage(x,y,n)=bitset(newimage(x,y,n),it,bitget(newcover(i,j,3),it));
        end
        if n<3
            n=n+1;
        else
            n=1;
            if y<messageSize(2)
                y=y+1;
            else
                x=x+1;
                y=1;
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
retrievedMessage = newimage

end

