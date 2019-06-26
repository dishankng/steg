function [ stegoImage, count, messageSize ] = LSBEncode( cover, messageImage )
%LSBENCODE Summary of this function goes here
%   Detailed explanation goes here

%cover=imread(coverImage);
message=imread(messageImage);
coverSize=size(cover);

messageSize=size(message);
%figure;
%title('Original(cover image)');
%image(cover)
%figure;
%image(message); % message image to be hidden
%title('message image to be hidden');

newcover=cover; 

% i,j for cover, x,y for message
i=1;j=1;x=1;y=1;
count=0; % no. of pixels of cover image used
for x=1:messageSize(1)
    for y=1:messageSize(2)
        for colInd=1:3
            colour=message(x,y,colInd);
            
            for it=3:-1:1
                newcover(i,j,1)=bitset(newcover(i,j,1),it,bitget(colour,it+5));
            end
            for it=3:-1:1
                newcover(i,j,2)=bitset(newcover(i,j,2),it,bitget(colour,it+2));
            end
            for it=2:-1:1
                newcover(i,j,3)=bitset(newcover(i,j,3),it,bitget(colour,it));
            end
            
            % might give error in certain cases
            
            if j<coverSize(2)
                j=j+1;
            else
                i=i+1;
                j=1;
            end
            count=count+1;    
        end
    end
end
stegoImage = newcover;
end

