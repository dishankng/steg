function [ newCover ] = MyHaar_Encode( cover,m,n )
%       lifting-
%     s = floor((A + B) / 2
%     d = A - B

    newCover=zeros(m,n,3,'int16');
    i=1;j=1;
    x=1;y=1;
    for i=1:m
        for j=1:2:n-1
            for it=1:3
                a=cover(i,j,it);
                b=cover(i,j+1,it);
                % normal method
                %newCover(x,y,it)=a+b;
                %newCover(x,y+floor(n/2),it)=a-b;
                
                %using lifting scheme
                newCover(x,y,it)=floor((a+b)/2);
                newCover(x,y+floor(n/2),it)=a-b;
            end
            if j==n
                break;
            end
            y=y+1;
        end
        x=x+1;
        y=1;
    end
    cover=newCover;
    x=1;y=1;
    for j=1:n
        for i=1:2:m-1
            for it=1:3
                a=cover(i,j,it);
                b=cover(i+1,j,it);
                %normal
%                 newCover(x,y,it)=a+b;
%                 newCover(x+floor(m/2),y,it)=a-b;
               
%               lifting-   
                newCover(x,y,it)=floor((a+b)/2);
                newCover(x+floor(m/2),y,it)=a-b;
            end
            if i==m
                break;
            end
            x=x+1;
        end
        y=y+1;
        x=1;
    end
%     cover=newCover;
%     if m>4 && n>4
%         newCover=calcDWT(cover,floor(m/2),floor(n/2));
%     end
end