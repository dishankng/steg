function [ original ] = MyHaar_Decode( newCover,m,n )
    original=zeros(m,n,3,'int16');
    %B = (s - d) / 2 , A = s - B;
%     with lifting-
%     A = s + floor((d + 1) / 2)
%     B = s - floor(d / 2)
    i=1;j=1;
    x=1;y=1;
    for j=1:n
        for i=1:floor(m/2)
            for it=1:3
                s=newCover(i,j,it);
                d=newCover(i+floor(m/2),j,it);
                %normal
%                 original(x,y,it)=(s+d)/2;
%                 original(x+1,y,it)=(s-d)/2;
                
                %lifting-
                original(x,y,it)=s+floor((d+1)/2);
                original(x+1,y,it)=s-floor(d/2);
            end
            x=x+2;
        end
        y=y+1;
        x=1;
    end
    newCover=original;
    x=1;y=1;
    for i=1:m
        for j=1:floor(n/2)
            for it=1:3
                s=newCover(i,j,it);
                d=newCover(i,j+floor(n/2),it);
                %normal
%                 original(x,y,it)=(s+d)/2;
%                 original(x,y+1,it)=(s-d)/2;
%                 
                %lifting
                original(x,y,it)=s+floor((d+1)/2);
                original(x,y+1,it)=s-floor(d/2);
            end
            y=y+2;
        end
        x=x+1;
        y=1;
    end
%     cover=newCover;
%     if m>4 && n>4
%         newCover=calcDWT(cover,floor(m/2),floor(n/2));
%     end
end

