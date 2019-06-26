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

% i,j for cover, x,y for message
i=1;j=1;x=1;y=1;
it=3;
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

figure;
image(newcover); % Cover image after image is hidden
title('Cover image after image is hidden');

% Now Data retreival
newimage=zeros(messageSize(1),messageSize(2),3,'uint8');

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

figure;
image(newimage);
title('Retreived image');
psnr = PSNR(cover, newcover);