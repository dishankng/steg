function [ psnr,afterLSB,stegoImage,count,messageSize  ] = HaarEncode( cover,messageImage )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    coverSize=size(cover);
    m=coverSize(1);
    n=coverSize(2);
% figure;
% image(cover);
% title('Original(cover image)');

els = {'p',[-0.125 0.125],0};
lshaarInt = liftwave('haar','int2int');
lsnewInt = addlift(lshaarInt,els);
[cAint,cHint,cVint,cDint] = lwt2(cover,lsnewInt);

liftedImg=zeros(m,n,3);
liftedImg(1:m/2,1:n/2,:)=cAint;
liftedImg(m/2 + 1:m,1:n/2,:)=cHint;
liftedImg(1:m/2,n/2+1:n,:)=cVint;
liftedImg(m/2+1:m,n/2+1:n,:)=cDint;

% figure;
% image(uint8(liftedImg));
% title('After haar wavelet and lifting');


[stegoImage, count, messageSize, ~] = LSBEncode(int16(cDint), messageImage);
cDint=double(stegoImage);
liftedImg(m/2+1:m,n/2+1:n,:)=cDint;

afterLSB=liftedImg;

% figure;
% image(uint8(liftedImg));
% title('After LSB embedding');

stegoImage= ilwt2(cAint,cHint,cVint,cDint,lsnewInt);

% figure;
% image(uint8(stegoImage));
% title('After Encoding');
psnr = PSNR(cover, stegoImage);

end

