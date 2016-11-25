function hfssDiscreteSweep(fid, Name, SolutionName, fStartGHz, ...
                                fStopGHz, nPoints)
                            
 %function hfssDiscreteSweep(fid, Name, SolutionName, fStartGHz, ...
%                                fStopGHz, [nPoints = 1000]]), 
%                         
% Soution frequency should be fixed at highest frequency
% Description :
% -------------
% Create the VB Script necessary to add an interpolating sweep to an existing
% solution.
% 
% Parameters :
% ------------
% fid          - file identifier of the HFSS script file.
% Name         - name of the interpolating sweep. 
% SolutionName - name of the solution to which this interpolating sweep needs
%                to be added.
% fStartGHz    - starting frequency of sweep in GHz.
% fStopGHz     - stop frequency of sweep in GHz.
% nPoints      - # of output points (defaults to 1000).

% Note :
% ------
%
% Example :
% ---------
% fid = fopen('myantenna.vbs', 'wt');
% ... 
% hfssDiscreteSweep(fid, 'Interp600to900MHz', 'Solve750MHz', 0.6, ...
%                        0.9, 1000);
%

fprintf(fid, '\n');
fprintf(fid, 'Set oModule = oDesign.GetModule("AnalysisSetup")\n');

fprintf(fid, 'oModule.InsertFrequencySweep _\n');
fprintf(fid, '"%s", _\n', SolutionName);
fprintf(fid, 'Array("NAME:%s", _\n', Name);
fprintf(fid, '"IsEnabled:=", true, _\n');
fprintf(fid, '"Type:=", "Discrete", _\n');
%fprintf(fid, '"InterpTolerance:=", %f, _\n', iTol);
%fprintf(fid, '"InterpMaxSolns:=", %d, _\n', nMaxSols);
fprintf(fid, '"SetupType:=", "LinearCount", _\n');
%fprintf(fid, '"SetupType:=", "SinglePoints", _\n');
fprintf(fid, '"StartFreq:=", "%fGHz", _\n', fStartGHz);
fprintf(fid, '"StopFreq:=", "%fGHz", _\n', fStopGHz);
fprintf(fid, '"Count:=", %d, _\n', nPoints);
fprintf(fid, '"SaveFields:=", true, _\n');
%  fprintf(fid, '"ValueList:=", Array("912MHz"), _\n');
%  fprintf(fid, '"SaveFieldsList:=", Array(false), _\n');
fprintf(fid, '"ExtrapToDC:=", false)\n');