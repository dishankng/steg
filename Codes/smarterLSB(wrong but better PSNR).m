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
i=1;j=1;
%x=1;y=1;
it=3;
count=0; % no. of pixels of cover image used

indI=(messageSize(1)*messageSize(2)*3)/coverSize(2);
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
n=1;
for x=1:messageSize(1)
    for y=1:messageSize(2)
        for colInd=1:3
            colour=message(x,y,colInd); % 8 bits of message
            
            pixel1= 4* bitget(newcover(i,j,1),3) + 2*bitget(newcover(i,j,1),2) + 1*bitget(newcover(i,j,1),1) + 1*bitget(newcover(i,j,2),1);
            
            pixel2= 4* bitget(newcover(i,j,2),3) + 2*bitget(newcover(i,j,2),2) + 2*bitget(newcover(i,j,3),2) + 1*bitget(newcover(i,j,3),1);
            
            % 1st case- msgLeft in pixel1, msgRight in pixel2
            
            msgLeft1=   4*bitget(colour,8) + 2*bitget(colour,7) + 1*bitget(colour,6) + 1*bitget(colour,5);
            msgRight2=  4*bitget(colour,4) + 2*bitget(colour,3) + 2*bitget(colour,2) + 1*bitget(colour,1);
            
            error1= abs (pixel1-msgLeft1) + abs(pixel2-msgRight2);
            
            % 2nd case - msgRight in pixel1 and msgLeft in pixel2
            
            msgLeft2=   4*bitget(colour,8) + 2*bitget(colour,7) + 2*bitget(colour,6) + 1*bitget(colour,5);
            msgRight1=  4*bitget(colour,4) + 2*bitget(colour,3) + 1*bitget(colour,2) + 1*bitget(colour,1);
            
            error2= abs (pixel1-msgRight1) + abs(pixel2-msgLeft2);
            
            if error1<=error2
                %put msgLeft in pixel1 and msgRight in pixel2
                newcover(i,j,1) = bitset(newcover(i,j,1),3,bitget(colour,8));
                newcover(i,j,1) = bitset(newcover(i,j,1),2,bitget(colour,7));
                newcover(i,j,1) = bitset(newcover(i,j,1),1,bitget(colour,6));
                newcover(i,j,2) = bitset(newcover(i,j,2),1,bitget(colour,5));
            
                newcover(i,j,2) = bitset(newcover(i,j,2),3,bitget(colour,4));
                newcover(i,j,2) = bitset(newcover(i,j,2),2,bitget(colour,3));
                newcover(i,j,3) = bitset(newcover(i,j,3),2,bitget(colour,2));
                newcover(i,j,3) = bitset(newcover(i,j,3),1,bitget(colour,1));
                
                newcover(indI,indJ,n) = bitset(newcover(indI,indJ,n),1,0); 
                
            else
                    %put msgRight in pixel1 and msgLeft in pixel2
                
                newcover(i,j,1) = bitset(newcover(i,j,1),3,bitget(colour,4));
                newcover(i,j,1) = bitset(newcover(i,j,1),2,bitget(colour,3));
                newcover(i,j,1) = bitset(newcover(i,j,1),1,bitget(colour,2));
                newcover(i,j,2) = bitset(newcover(i,j,2),1,bitget(colour,1));
            
                newcover(i,j,2) = bitset(newcover(i,j,2),3,bitget(colour,8));
                newcover(i,j,2) = bitset(newcover(i,j,2),2,bitget(colour,7));
                newcover(i,j,3) = bitset(newcover(i,j,3),2,bitget(colour,6));
                newcover(i,j,3) = bitset(newcover(i,j,3),1,bitget(colour,5));
                
                newcover(indI,indJ,n) = bitset(newcover(indI,indJ,n),1,1); 
                
            end
            if n<3
                n=n+1;
            else
                n=1;
                if indJ<coverSize(2)
                    indJ=indJ+1;
                else
                    indI=indI+1;
                    indJ=1;
                end
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
indI=origIndI;
indJ=origIndJ;

numErrors=0;
for i=1:coverSize(1)
    for j=1:coverSize(2)
        revPixel1=[bitget(newcover(i,j,2),1),bitget(newcover(i,j,1),1),bitget(newcover(i,j,1),2),bitget(newcover(i,j,1),3)];
        
        revPixel2=[bitget(newcover(i,j,3),1),bitget(newcover(i,j,3),2),bitget(newcover(i,j,2),2),bitget(newcover(i,j,2),3)];
       
        
        if bitget(newcover(indI,indJ,n),1)==0
            %pixel1 will go to left, pixel2 to right
            for it=4:-1:1
                newimage(x,y,n)=bitset(newimage(x,y,n),it+4,revPixel1(it));
            end
            for it=4:-1:1
                newimage(x,y,n)=bitset(newimage(x,y,n),it,revPixel2(it));
            end
        else
            %pixel1 will go to right, pixel2 to left
            for it=4:-1:1
                newimage(x,y,n)=bitset(newimage(x,y,n),it+4,revPixel2(it));
            end
            for it=4:-1:1
                newimage(x,y,n)=bitset(newimage(x,y,n),it,revPixel1(it));
            end
        end
        if newimage(x,y,n)~= message(x,y,n)
            numErrors=numErrors+1;
        end
        if n<3
            n=n+1;
        else
            n=1;
            if indJ<coverSize(2)
                indJ=indJ+1;
            else
                indI=indI+1;
                indJ=1;
            end
            
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