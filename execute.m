clear;clc;clf;

% Add paths to the required m-files.
addpath('./api/'); % add manually the API root directory.
hfssIncludePaths('./api/');

tmpPrjFile    = [pwd, '\patch.hfss'];
tmpDataFile   = [pwd, '\tmpData.m'];
tmpScriptFile = [pwd, '\script.vbs'];
% HFSS14.0 - 'C:\"Program Files"\"Ansoft"\"HFSS14.0"\"Win64"\hfss.exe';
% HFSS15.0 - 'C:\Program Files\AnsysEM\HFSS15.0\Win64\hfss.exe'
hfssExePath = 'C:\"Program Files"\"Ansoft"\"HFSS14.0"\"Win64"\hfss.exe';

j=1;
fre=10.6;
tic;
Wf=3;
Lf=12.5;
Lg=11.5;

x0=Wf/2;
x1=8.22;
x2=8.02;
x3=10.69;
x4=7.75;
x5=4.24;
y0=Lf;
y1=2.47;
y2=2.96;
y3=3.66;
y4=3.51;
y5=3.91;
up=300/3.1;
up=up/4;

% include path for VBscript
fid = fopen(tmpScriptFile, 'wt');
    
% Create a new HFSS Project and insert a new design.
hfssNewProject(fid);
hfssInsertDesign(fid, 'polyline');

hfssPolyline(fid, 'poly1',[x0, 0, 0 ;x0, y0, 0; x1, y0+y1, 0;x2, y0+y1+y2, 0 ;x3, y0+y1+y2+y3, 0 ;x4, y0+y1+y2+y3+y4, 0;x5, y0+y1+y2+y3+y4+y5, 0;-x5, y0+y1+y2+y3+y4+y5, 0;-x4, y0+y1+y2+y3+y4, 0;-x3, y0+y1+y2+y3, 0 ;-x2, y0+y1+y2, 0 ;-x1, y0+y1, 0;-x0, y0, 0;-x0, 0, 0 ;x0, 0, 0],...
                      'mm','true','Line',[132 132 132],0.6);

% hfssAddMaterial(fid, 'poly1', 1, 58000000, 0);
% hfssAddMaterial(fid, 'CoaxDielectric', 2.07, 0, 0);
hfssBox(fid, 'box1', [-15,0,-1.5], [30,30,1.5], 'mm',.9);
hfssAssignMaterial(fid, 'box1', 'FR4_epoxy');
hfssRectangle(fid, 'Ground', 'Z', [-15,0,-1.5], 30,Lg, 'mm');

%hfssAddMaterial(fid, 'Ground', 1, 58000000, 0);

hfssAssignPE(fid, 'PerfE2',{'poly1'},0);
hfssAssignPE(fid, 'GNDplane',{'Ground'},0);
% hfssAssignMaterial(fid, 'Ground', 'copper'); 
% hfssAssignMaterial(fid, 'poly1', 'copper'); 

hfssRectangle(fid, 'wprt', 'Y', [-7.5,0,-1.5], 4.5, 15, 'mm')
% hfssAssignMaterial(fid, 'src', 'copper'); 
% hfssAddMaterial(fid, 'src', 1, 58000000, 0);
hfssAssignWavePort(fid,'wprt', 'wprt', 1, true, [0,0,0], ...
                  [0,0,-1.5], 'mm');

% hfssAssignLumpedPort(fid, 'lumport', 'src', [0,0,0], [0,0,-1.5], 'mm',50.0, 0.0);
 
hfssBox(fid, 'box2', [-15,0,-up], [30,30,(2*up)], 'mm',.9);
hfssAssignMaterial(fid, 'box2', 'air')
hfssAssignRadiation(fid, 'ABC','box2');
     
%hfssAssignInfinityPE(fid,'GNDplane');
hfssInsertSolution(fid, 'setupx1', fre, 0.02, 25, 1,1,20);
%hfssSaveProject(fid, tmpPrjFile, true);
%hfssSaveProject(fid, strcat(pa,'\vamsi.hfss'), true)

% hfssAssignFiniteCond(fid, 'HBox', 'Ground', 'air', 'mango', true); 
      
%hfssInterpolatingSweep(fid, 'Interp', 'setupx1', 3.1, ...
%                10.6, 175, 40, 0.75);

hfssDiscreteSweep(fid, 'Interp', 'setupx1', 3.1, ...
                    10.6, 30);
hfssInsertFarFieldSphereSetup(fid, 'Radiation',[0,360,1], [0,0,1]);
hfssSolveSetup(fid, 'setupx1');
    
hfssCreateReport(fid,'XYplot', 1, 1, 'setupx1',...
                    'Interp', [], 'Sweep', {'Freq'},  {'Freq',...
                    'dB(S(wprt,wprt))'});
%    hfssExportNetworkData(fid, tmpDataFile, 'setupx1', ...
%                           'Interp');

hfssExportToFile(fid,'XYplot' ,strcat(pwd,'\noteN') , 'm')
hfssCreateReport(fid,'XYplot1', 5, 1, 'setupx1',...
                 'Interp', 'Radiation', [], {'Theta','Phi', 'Freq' },  {'Theta',...
                 'GainTotal'},'0deg','7.7551724137931GHz');
               
hfssExportToFile(fid,'XYplot1' ,strcat(pwd,'\note1') , 'm')
                 
hfssInsertFarFieldSphereSetup_modified(fid, 'Radiation',[40,40,1], [90,90,1]);
% hfssInsertFarFieldSphereSetup(fid, 'Radiation',[0,360,1], [0,0,1]);
       
hfssCreateReport(fid,'XYplot2', 5, 1, 'setupx1',...
                     'Interp', 'Radiation', [], {'Freq', 'Theta','Phi' },  {'Freq',...
                     'PeakDirectivity'});
                   
hfssExportToFile(fid,'XYplot2' ,strcat(pwd,'\note2') , 'm')
                   
                   
hfssCreateReport(fid,'XYplot3', 5, 1, 'setupx1',...
                     'Interp', 'Radiation', [], {'Freq', 'Theta','Phi' },  {'Freq',...
                     'RadiationEfficiency'});
hfssExportToFile(fid,'XYplot3' ,strcat(pwd,'\note3') , 'm')         

% hfssExportToFile(fid,'XYplot2' ,strcat(pwd,'\note2') , 'm')
            
     
hfssSaveProject(fid, tmpPrjFile, true);

fclose('all');

disp('Solving using HFSS...');
      
% hfssExecuteScript(hfssExePath,tmpScriptFile,true,false);
hfssExecuteScript(hfssExePath,tmpScriptFile,true,false);
       
% Load the data by running the exported matlab file.
% run(tmpDataFile);
% tmpDataFile = [pwd, '\tmpData', '.m']; 
% [heffi2, RadEff] = hdrload('farFieldEff.m');
% radF=RadEff(:,1);
% RE=RadEff(:,2);

[freq1,GainTotal]=hfssplot('note1','m');
figure(1);
plot(freq1,GainTotal);
xlabel('Frequency (GHz)');
ylabel('GainTotal');
    
[freq2,PeakDirectivity]=hfssplot('note2','m');
figure(2);
plot(freq2,PeakDirectivity);
xlabel('Frequency (GHz)');
ylabel('PeakDirectivity');
    
[freq3,RadiationEfficiency]=hfssplot('note3','m');
figure(3);
plot(freq3,RadiationEfficiency);
xlabel('Frequency (GHz)');
ylabel('RadiationEfficiency');
       
% The data items are in the f, S, Z variables now. 
% Plot the data.
[f,S]=hfssplot('noteN','m');
S=20*log10(abs(S));
figure(4);
% hold on; grid on;
% subplot(2,2,1);
plot(f/1e9, S); 
% hold on;
xlabel('Frequency (GHz)');
ylabel('S_{11} (dB)');
cost=sum(S);
   
% Remove all the added paths.
hfssRemovePaths('./api/');
rmpath('./api/');
        