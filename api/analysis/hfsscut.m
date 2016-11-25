% 
%  source :- The rectangle from which unit cell is cut
%  a      :- the two dimensional matrix which represents the position to remove unit cell
%            1:- unit cell is cut
%            0:- unit cell is not cut
%   px    :- X- position of source rectangle
%   py    :- Y-postion of source rectangle
% 

function hfsscut(fid,source,a,px,py,lx,bx,l,b,axis)


  ly=ceil(lx/l)
  by=ceil(bx/b)
   if(l>2)
  x=[.5 1 2];
   else
    x=[.5 1];
   end
if(b>2)
  y=[.5 1 2];
   else
    y=[.5 1];
   end 


 j=1;
r=length(a);
 %[r c]=size(a);
for j=1:by
    for i=1:ly
        if(r>0)
            if(a(r)>0)
      hi=num2str(i);
      hj=num2str(j);
      name=strcat('smallr',hj,'c',hi);
       pos = randi(length(x));
       card1 = x(pos);
        pos = randi(length(y));
       card2 = y(pos);
      hfssRectangle(fid, name, axis, [px+(i-1)*l,py+(j-1)*b,0], l-card1,b-card2, 'mm');
      hfssSubtract(fid, source, name);
        end
        end
        r=r-1;
    end
end
%  for i=1:r
%      if(a(i)>0)
%          hj=num2str(j);
%       hi=num2str(i);
%       name=strcat('smallr',hi,'c',hj);
%       hfssRectangle(fid, name, axis, [px+(i-1)*l,py+(j-1)*b,0], l,b, 'mm');
%       hfssSubtract(fid, source, name);
%      end
%  end
 
 

 
end
 
 
 
 