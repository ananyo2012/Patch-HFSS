function cost=patch_polyline(x, varargin)

    % Add paths to the required m-files
    addpath('./api/'); % add manually the API root directory
    hfssIncludePaths('./api/');
    
    % Temporary Files. These files can be deleted after the optimization
    % is complete. We have to specify the complete path for all of them.
    % With pwd we save them in the current directory.

    tmpPrjFile    = [pwd, '\patch.hfss'];
    tmpDataFile   = [pwd, '\tmpData.m'];
    tmpScriptFile = [pwd, '\script.vbs'];
    % HFSS Executable Path
    % HFSS14.0 - 'C:\"Program Files"\"Ansoft"\"HFSS14.0"\"Win64"\hfss.exe'
    % HFSS15.0 - 'C:\Program Files\AnsysEM\HFSS15.0\Win64\hfss.exe'
    hfssExePath = 'C:\"Program Files"\"Ansoft"\"HFSS14.0"\"Win64"\hfss.exe';

    Wf=3;
    Lf=12.5;
    Lg=11.5;

    x0=Wf/2;
    y0=Lf;
    %[x1, x2, x3, x4, x5, y1, y2 ,y3, y4, y5]=x(1:10);
    % x1=8.22;
    % x2=8.02;
    % x3=10.69;
    % x4=7.75;
    % x5=4.24; 

    % y1=2.47;
    % y2=2.96;
    % y3=3.66;
    % y4=3.51;
    % y5=3.91;
    x1=x(1);
    x2=x(2);
    x3=x(3);
    x4=x(4);
    x5=x(5);

    y1=x(6);
    y2=x(7);
    y3=x(8);
    y4=x(9);
    y5=x(10);
    
    fc=6;% Solution frequency in GHZ
    

    % Create a new temporary HFSS script file
    fid = fopen(tmpScriptFile, 'wt');
    
    % Create a new HFSS Project and insert a new design
    hfssNewProject(fid);
    hfssInsertDesign(fid, 'polyline');
    %include path for VBscript 
    %fid = fopen('C:\Users\User\Desktop\project\project\Hfss-api\antenna.vbs', 'wt+');
    %hopen(fid);
    hfssPolyline(fid, 'poly1',[x0, 0, 0 ;x0, y0, 0; x1, y0+y1, 0;x2, y0+y1+y2, 0 ;x3, y0+y1+y2+y3, 0 ;x4, y0+y1+y2+y3+y4, 0;x5, y0+y1+y2+y3+y4+y5, 0;-x5, y0+y1+y2+y3+y4+y5, 0;-x4, y0+y1+y2+y3+y4, 0;-x3, y0+y1+y2+y3, 0 ;-x2, y0+y1+y2, 0 ;-x1, y0+y1, 0;-x0, y0, 0;-x0, 0, 0 ;x0, 0, 0],...
                      'mm','true','Line',[132 132 132],0.6);
    hfssBox(fid, 'box1', [-15,0,-1.5], [30,30,1.5], 'mm',.9);
    hfssAssignMaterial(fid, 'box1', 'FR4_epoxy');
    hfssRectangle(fid, 'Ground', 'Z', [-15,0,-1.5], 30, Lg, 'mm');
    
    hfssAssignPE(fid, 'Pe1', {'poly1'},false);
    hfssAssignPE(fid, 'Pe2', {'Ground'},true);
    
    hfssRectangle(fid, 'src', 'Y', [-6.0,0,-1.5], 3, 12.0, 'mm')
    hfssAssignWavePort(fid,'wprt', 'src', 1, false, [0,0,0], ...
                  [0,0,-1.5], 'mm');
    hfssBox(fid, 'box2', [-15,0,-4], [30,30,12], 'mm',.9);
    hfssAssignMaterial(fid, 'box2', 'air')
    hfssAssignRadiation(fid, 'ABC','box2');
    
    hfssInsertSolution(fid, 'setupx1', fc, 0.02, 25, 1,1,20);
    hfssInterpolatingSweep(fid, 'Interp', 'setupx1', 3.1, ...
                        10.6, 76, 101, 0.5);
    hfssSolveSetup(fid, 'setupx1');
    % hfssInsertFarFieldSphereSetup(fid, 'EPlaneCutSphere', [0 360 1], [90 90 1]);
    % hfssInsertFarFieldSphereSetup(fid, 'HPlaneCutSphere', [90 90 1], [0 360 1]);
             
    % hfssCreateReport(fid,'XYplot', 1, 1, 'setupx1',...
    %                'Interp', [], 'Sweep', {'Freq'},  {'Freq',...
    %                'dB(S(wprt,wprt))'});
                
    % hfssCreateReport(fid, 'E Place Cut (polar)', 5,3, 'setupx1', [],...
    %                       'EPlaneCutSphere', [], {'Theta', 'Phi', 'Freq'},...
    %                       {'Theta', 'dB(DirTotal)'});
    % hfssCreateReport(fid, 'H Plane Cut (cart.)', 5,3, 'setupx1', [],...
    %                   'HPlaneCutSphere', [], {'Phi', 'Theta', 'Freq'},...
    %                   {'Phi', 'dB(DirTotal)'});
    
    % give the path where pgh is stored
    % this generates a text file 'note.txt' which includes
    % frequencies and S11 values
    % hfssExportToFile(fid,'XYplot' ,'C:\Users\User\Desktop\project\project\Hfss-api\note' , 'txt')
    % hfssCreateReport(fid, '3D Diagram Cart.', 5, 6, 'setupx1', [],...
    %                   'Diagram3D', [], {'Theta', 'Phi', 'Freq'},...
    %                   {'Theta', 'Phi', 'dB(DirTotal)'});
 
    % give the path where Hfss file must be stored
    hfssSaveProject(fid, tmpPrjFile, true);
    hfssExportNetworkData(fid, tmpDataFile, 'Setupx1', ...
                               'Interp');
     
    % Close the HFSS Script File.
    fclose(fid);
    % fclose('all');
     
    % Execute the script.
    % give the complete path where 'hfss.exe' is stored
    % and give the path where VBScript is generated
    disp('Solving using HFSS...');
    % hfssExecuteScript(hfssExePath,tmpScriptFile,true,false);
    hfssExecuteScript(hfssExePath,tmpScriptFile,true,true);
       
   % Load the data by running the exported matlab file.
   run(tmpDataFile);
   tmpDataFile = [pwd, '\tmpData', '.m'];    
   % The data items are in the f, S, Z variables now. 
   % Plot the data.
   S=20*log10(abs(S));
   cost=sum(S);
   
   % Remove all the added paths.
    hfssRemovePaths('./api/');
    rmpath('./api/');
end
       
%  fid = fopen('note.txt', 'r') ;              % Open source file.
%  fgetl(fid) ;                                % Read/discard line.
%  fgetl(fid) ;
%  fgetl(fid) ;
%  fgetl(fid) ;
%  fgetl(fid) ;
%  fgetl(fid) ;
%  fgetl(fid) ;                                 % Read/discard line.
%  buffer = fread(fid, Inf) ;                   % Read rest of the file.
%  fclose('all')
%  fid = fopen('cry.txt', 'w')  ;               % Open destination file.
%  fwrite(fid, buffer) ;                        % Save to file.
%  fclose('all') ;
%  load cry.txt
%  time=cry();
%  [m,n]=size(time);
%  for n=1:m
%    if (time(n,1)>2.4)
%      break;
%    end
%  end
%  s11=time(n,2)
%  val=time();
%  s11=time(:,2);
%  freq=time(:,1);
%  plot(freq,s11);
%  xlabel('Frequency');
%  ylabel('S11(dB)');
               