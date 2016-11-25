function [data, fit_count, gbest_find, gbestval, worst, std_deviation, Mean, eltime, evalue] = qpso(rngseed, RUNNO,Max_Gen,Particle_Number,Dimension,VRmin,VRmax,levyflight,filename,handles)
%[gbest_find,gbestval_find,fitcount,std_deviation,Mean]= qpso('failure_mutual1',3,500,10000,40,30,0,1,varargin)

tic;
fhd=filename;
% RUNNO=1;
% Max_Gen=500;
% Max_FES=20000;
% Particle_Number=30;
% Dimension=6;
% VRmin=[0.30*ones(1,6) 0.10*ones(1,5)];
% VRmax=[0.70*ones(1,6) 0.45*ones(1,5)];

% VRmin=0;VRmax=5;

%elite=2;
%varargin=[];

%rand('twister',sum(100*clock));
rng(rngseed,'twister'); % sample value = 999
%rand('twister',96);
me=Max_Gen;
ps=Particle_Number;
D=Dimension;
%MutationProbability=1/D;
mvcrit=2;
cnt3=0;
cnt2=0;
ergrd=1e-9;
ergrdep=100;

if length(VRmin)==1
    VRmin=repmat(VRmin,1,D);
end

if length(VRmax)==1
    VRmax=repmat(VRmax,1,D);
end

runno=RUNNO;
VRmin=repmat(VRmin,ps,1);
VRmax=repmat(VRmax,ps,1);
data=zeros(runno,me);
M=(VRmax-VRmin)/2;
for run=1:runno                     %Start run loop
    pos=VRmin+(VRmax-VRmin).*rand(ps,D);


    for i=1:ps;
        e(i,1)=feval(fhd, pos(i,:));
    end
    [e, indices] = sort(e, 'ascend');
    pos = pos(indices, :);
    fitcount=ps;

    pbest=pos;
    pbestval=e; %initialize the pbest and the pbest's fitness value
    [gbestval,gbestid]=min(pbestval);
    gbest=pbest(gbestid,:);%initialize the gbest and the gbest's fitness value
    gbestrep=repmat(gbest,ps,1);
    % tr(1)=gbestval;
    % average(1)=mean(e);

for i=1:me          %start iteration loop
    
    
    % EliteSolutions = pos(1 : NumberOfElites, :);
%           mutmin=1/ps;mutmax=1;
%         MutationProbability=(mutmin-mutmax)/(me-1)*(i-1)+mutmax;
%        MutationProbability=1/ps;
       MutationProbability=1/D;
%     MutationProbability=(mutmax-mutmin)/(me-1)*(i-1)+mutmin;
    
    select = handles.select;
    switch select
        case 1
           alphamin = str2num(get(handles.alphamin,'String'));
           alphamax = str2num(get(handles.alphamax,'String'));
           alpha=(alphamax-alphamin)*(me-i)/(me-1)+alphamin;
        case 2
           select_list = get(handles.listbox,'Value');
           switch select_list
               case 1
                  alpha = str2num(get(handles.alpha,'String'));
               case 2
                  alpha=0.4+rand(1,1)/2;
               case 3
                  alpha=0.5+0.5*cos(0.5*pi*i/me);
           end
    end
    %alpha=0.75;
    
    %alphamax=0.7;alphamin=0.01;
    %alphamax=0.7;alphamin=0.4;
    %alphamax=1.0;alphamin=0.5;
    
     beta=rand(ps,D);   
    %beta=rand;   
  % mbest=sum(pbest)/ps;
    mbest=sum(beta.*pbest+(1-beta).*gbestrep)/ps;
%     VRmin=VRmin+0.5*(gbestrep-VRmin);
%     VRmax=VRmax-0.5*(VRmax-gbestrep);
    for k=1:ps      %start particle loop
      r1=rand(1,D);
      r2=rand(1,D);
%      r1=abs(randn(1,D));
%       r2=abs(randn(1,D));

%      r1=expo_rand(0.01,1,D);
%      r2=expo_rand(0.01,1,D);
%       
     
    %aa(k,:)=r1.*pbest(k,:)+(1-r1).*gbestrep(k,:);
    aa(k,:)=(r1.*pbest(k,:)+r2.*gbestrep(k,:))./(r1+r2);
    u=rand(1,D);
%      u=expo_rand(0.01,1,D);
   %u=abs(randn(1,D));
%     r3=expo_rand(0.1,1,D);
    r3=rand(1,D);    
%       
       
    pos(k,:)=aa(k,:)+((-1).^ceil(0.5+r3)).*(alpha.*abs(mbest-pos(k,:)).*log(1./u)); 
%    
      
%      ***********************************************************************
%      Levy flight distribution start
%      *************************************************************************

beta=3/2;
sigma=(gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);


    s=pos(k,:);
    % This is a simple way of implementing Levy flights
    % For standard random walks, use step=1;
    %% Levy flights by Mantegna's algorithm
    u=randn(size(s))*sigma;
    v=randn(size(s));
    step=u./abs(v).^(1/beta);
  
    % In the next equation, the difference factor (s-best) means that 
    % when the solution is the best solution, it remains unchanged.     
    stepsize=0.01*step.*(s-gbestrep(k,:));
    % Here the factor 0.01 comes from the fact that L/100 should the typical
    % step size of walks/flights where L is the typical lenghtscale; 
    % otherwise, Levy flights may become too aggresive/efficient, 
    % which makes new solutions (even) jump out side of the design domain 
    % (and thus wasting evaluations).
    % Now the actual random walks or flights
    if levyflight
     pos(k,:)=pos(k,:)+stepsize.*randn(size(s));
    end
%     if rand < MutationProbability
%     pos(k,:)=pos(k,:)+stepsize.*randn(size(s));
%     end
%    for ParameterIndex = 1 : D
%             if rand < MutationProbability
%    pos(k,ParameterIndex)=pos(k,ParameterIndex)+stepsize(ParameterIndex)*randn;
%             end
%    end
  

%       **********************************************************************
%      Levy flight distribution end
%      *************************************************************************

%     **********************************************************************
%      Mutation start
%      *************************************************************************
if get(handles.mutation,'Value') == get(handles.mutation,'Max')
    MutationProbability = str2num(get(handles.mutation_probability,'String'));
     for ParameterIndex = 1 : D
            if rand < MutationProbability
               % pos(k, ParameterIndex) = VRmin(k, ParameterIndex) + (VRmax(k, ParameterIndex) - VRmin(k, ParameterIndex)) * rand;
                pos(k, ParameterIndex) = pos(k, ParameterIndex) + (VRmax(k, ParameterIndex) - VRmin(k, ParameterIndex)) * rand;
                % pos(k, ParameterIndex) = pos(k, ParameterIndex) + 0.5*gbestrep(k,ParameterIndex)* randn;
            end
     end
end

%      ******* **********************************************************************
%      Mutation End
%      ********************************************************************
%  pos(k,:)=max(pos(k,:),VRmin(k,:));
%     pos(k,:)=min(pos(k,:),VRmax(k,:));
    %pos(k,:)=pos(k,:)-(VRmax(k,:)+VRmin(k,:))/2;
    %pos(k,:)=sign(pos(k,:)).*min(abs(pos(k,:)),M(k,:));
%     pos(k,:)=pos(k,:)+(VRmax(k,:)+VRmin(k,:))/2;
   % pos(k,:)=((pos(k,:)>=VRmin(k,:))&(pos(k,:)<=VRmax(k,:))).*pos(k,:)...
     %   +(pos(k,:)<VRmin(k,:)).*(VRmin(k,:)+0.25.*(VRmax(k,:)-VRmin(k,:)).*rand(1,D))+(pos(k,:)>VRmax(k,:)).*(VRmax(k,:)-0.25.*(VRmax(k,:)-VRmin(k,:)).*rand(1,D));
 pos(k,:)=((pos(k,:)>=VRmin(k,:))&(pos(k,:)<=VRmax(k,:))).*pos(k,:)...
         +(pos(k,:)<VRmin(k,:)).*(VRmin(k,:)+(VRmax(k,:)-VRmin(k,:)).*rand(1,D))+(pos(k,:)>VRmax(k,:)).*(VRmin(k,:)+(VRmax(k,:)-VRmin(k,:)).*rand(1,D));
%  pos(k,:)=((pos(k,:)>=VRmin(k,:))&(pos(k,:)<=VRmax(k,:))).*pos(k,:)...
%          +(pos(k,:)<VRmin(k,:)).*(VRmin(k,:)+(pos(k,:)-VRmin(k,:)).*rand(1,D))+(pos(k,:)>VRmax(k,:)).*(VRmax(k,:)-(VRmax(k,:)-pos(k,:)).*rand(1,D));

     
    e(k,1)=feval(fhd, pos(k,:));
    fitcount=fitcount+1;
    tmp=(pbestval(k)<e(k));
    temp=repmat(tmp,1,D);
    pbest(k,:)=temp.*pbest(k,:)+(1-temp).*pos(k,:);
    pbestval(k)=tmp.*pbestval(k)+(1-tmp).*e(k);%update the pbest
    if pbestval(k)<gbestval
        gbest=pbest(k,:);
        gbestval=pbestval(k);
        gbestrep=repmat(gbest,ps,1);%update the gbest
    end
   % end
    tr(i+1)=gbestval;
    
    end         %end particle loop

    %% Elitism start
% if get(handles.elitism,'Value') == get(handles.elitism,'Max')
%    elite = str2num(get(handles.elite,'String'));
%    [e, indices] = sort(e, 'ascend');
%        pos = pos(indices, :);
%     for y = 1 : elite
%         pos(ps-(y-1),:) = pos(y,:);
%         e(ps-(y-1)) = e(y);
%     end
% end
   %% Elitism ends here 
   
    % [gbestval,gbestid]=min(e);
    % gbest=pos(gbestid,:);

    fprintf('Run=%d Iter=%d BestFitnessValue=%g\n',run,i,gbestval);
    set(handles.runs,'String',num2str(run));
    set(handles.iterations,'String',num2str(i));
    set(handles.bestfit,'String',num2str(gbestval));
    drawnow;
   
   % check for stopping criterion based on speed of convergence to desired error 
%    if tr(i)~=gbestval
%     cnt2=0;
%  elseif tr(i)==gbestval
%      cnt2=cnt2+1;
%     if cnt2>=ergrdep
%      %  disp('***************************** global error gradient too small for too long');     
%         break  
%      end
%     end
  %tmp1=abs(tr(i)-gbestval);
  %if tmp1>ergrd
   %  cnt2=0;
  %elseif tmp1<=ergrd
    % cnt2=cnt2+1;
     %if cnt2>=ergrdep
      %  disp('***************************** global error gradient too small for too long');     
       % break
     %end       
  %end
    
% if round(i/20)==i/20
%     plot(pos(:,1),pos(:,2),'b*');hold on
%     plot(pbest(:,1),pbest(:,2),'r*');hold off

%     title(['PSO: ',num2str(i),' generations, Gbestval=',num2str(gbestval)]); 
%     axis([-100,100,-100,100]);
%     drawnow
% end
%if fitcount>=Max_FES
 %   break;
 %end
%  if gbestval<=0.1
%      
%     break;
%  end
 data_mean(run,i)=mean(e);
 data(run,i)=gbestval;
 gbest_data(run,:)=gbest;
 fit_count(run,i)=fitcount;
 evalue(run,i,:) = e';
 
  
end     %end iteration loop
% if gbestval<=0.1
%         break;
%  end
end     %end run loop
Maxfit_count=fitcount
[gbestval_find,L]=min(data(:,end));
gbest_find=gbest_data(L,:)
gbestval=gbestval_find
if runno == 1
    worst=max(data)
    std_deviation=std(data,1)
    Mean=mean(data)
else   
    worst=max(data(:,end))
    std_deviation=std(data(:,end),1)
    Mean=mean(data(:,end))
end
assignin('base','gbest_find',gbest_find);
assignin('base','gbestval',gbestval_find);
assignin('base','data',data);
assignin('base','data_mean',data_mean);
assignin('base','fit_count',fit_count);

%save gkm2.mat;
% std_deviation=std(data(L,:),1);
% Mean=mean(data(L,:));

% figure(1);
% plot([0,1:iteration],tr);
% figure(1)
% if runno == 1
%     plot(data);
% else
%     plot(mean(data));
% end

% figure(2)
% if runno==1
%     plot(fit_count(runno,:),data);
% else
%     plot(fit_count(runno,:),mean(data));
% end

eltime = toc;
return
function y=expo_rand(a,b,D)
%a=0.3;b=1;
% generation of random numbers using 
%exponential distribution
u1 =rand(1,D); %uniform random number [0;1]
u2 =rand(1,D); %uniform random number [0;1]

x=a+b*(-1).^ceil(0.5+u1).*log(u2);
y=abs(x);

%  if u1 >0.5
%  x = a+b*log( u2 );
%  else
%  x = a-b*log( u2 );
%  end
% y = abs(x); % absolute value 
return
% function pos=uniform_mutation(k,pos,D,VRmin,VRmax,MutationProbability)
% 
% 
%         for ParameterIndex = 1 : D
%             if rand < MutationProbability
%                 pos(k, ParameterIndex) = VRmin(k, ParameterIndex) + (VRmax(k, ParameterIndex) - VRmin(k, ParameterIndex)) * rand;
%             end
%         end
%         
%           
% 
%  return


