function [ retrievedMessage ] = haarDecode( stegoImage,count,messageSize )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    els = {'p',[-0.125 0.125],0};
    lshaarInt = liftwave('haar','int2int');
    lsnewInt = addlift(lshaarInt,els);
    [cAint,cHint,cVint,cDint] = lwt2(stegoImage,lsnewInt);

    retrievedMessage  = LSBDecode( count,int16(cDint), messageSize);
end

