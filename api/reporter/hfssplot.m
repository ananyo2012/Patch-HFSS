% 
% name :- Name of the  file intp which it is exported
% type :- type of the file
%          ex:-.'.m','.txt'
%   Xl :- X label of the plot
%   Yl :- Y label of the plot

function [x,y]= hfssplot(name,type)
       Name=strcat(name,'.',type)
       Name_A=strcat('hall.',type)
    
                   % Open source file.
    
   
       fid = fopen( Name, 'r');             % Open source file.
 fgetl(fid) ;                                  % Read/discard line.
 fgetl(fid) ;
 fgetl(fid) ;
 fgetl(fid) ;
 fgetl(fid) ;
 fgetl(fid) ;
 fgetl(fid) ;                                  % Read/discard line.
 buffer = fread(fid, Inf) ;                    % Read rest of the file.
  fclose('all') ;
 fid = fopen( Name_A, 'w')  ;   % Open destination file.
 fwrite(fid, buffer) ;                         % Save to file.
  fclose('all') ;
 load ( Name_A);
 time=hall();
 %[m,n]=size(time);
  %for n=1:m
   %   if (time(n,1)>2.4)
    %      break;
     % end
 % end
  % s11=time(n,2)
  
  s11=time(:,2);
  freq=time(:,1);
  x=freq;
  y=s11;
  %subplot(2,2,2);
%  fig= plot(freq,s11);
%   xlabel(Xl);
%   ylabel(Yl);
 toc

   delete ( Name_A);
end
  
 