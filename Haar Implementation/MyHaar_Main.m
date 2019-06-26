cover=imread('sunflower.jpg');

figure;
image(cover);
title('original');

cover=double(cover);
coverSize=size(cover);
m=coverSize(1);n=coverSize(2);
% m vertical, n horizontal

newCover=MyHaar_Encode(cover,m,n);

img=uint8(newCover);
figure;
image(img);
title('after haar wavelet trans');

I1=newCover(1:m/2,1:n/2,:);
I2=newCover(m/2 + 1:m,1:n/2,:);
I3=newCover(1:m/2,n/2+1:n,:);
I4=newCover(m/2+1:m,n/2+1:n,:);

%Encode
[ stegoImage, count, messageSize ] = LSBEncode(int16(I4),'main.bmp');
I4=double(stegoImage);
newCover(m/2+1:m,n/2+1:n,:)=I4;

img=uint8(newCover);
figure;
image(img);
title('after LSB embedding');


original=MyHaar_Decode(newCover,coverSize(1),coverSize(2));

img=uint8(original);
figure;
image(img);
title('after IWT');

%Decode
newCover=MyHaar_Encode(original,m,n);
I4=newCover(m/2+1:m,n/2+1:n,:);

retrievedMessage = LSBDecode( count, int16(I4), messageSize );
figure;
image(retrievedMessage);
title('Retrieved Message');