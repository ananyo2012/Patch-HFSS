function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 11-Aug-2016 14:16:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;
set(findobj(handles.figure1),'Units','characters');
title(handles.plot, 'No of iteration vs mean best fitness values of QPSO Algorithm');
xlabel(handles.plot, 'No of iterations');
ylabel(handles.plot, 'Mean of best fitness values');

set(handles.buttongroup,'selectedobject',handles.select_alphamin_alphamax);
handles.select = 1;
set(handles.listbox,'Enable','off');
set(handles.alpha,'Enable','off');
set(handles.mutation_probability, 'Enable', 'off');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in execute.
function execute_Callback(hObject, eventdata, handles)
% hObject    handle to execute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    set(handles.gbest_find,'String', '');
    set(handles.gbest,'String','');
    set(handles.mean,'String','');
    set(handles.std_deviation,'String','');
    set(handles.worst,'String','');
    set(handles.eltime,'String','');
    cla reset
    title(handles.plot, 'No of iteration vs mean best fitness values of QPSO Algorithm');
    xlabel(handles.plot, 'No of iterations');
    ylabel(handles.plot, 'Mean of best fitness values');
    
    Particle_Number=str2num(get(handles.particle_no,'String'));
    RUNNO=str2num(get(handles.runno,'String'));
    Max_Gen=str2num(get(handles.maxgen,'String'));
    Dimension=str2num(get(handles.dim,'String'));
    VRmin=str2num(get(handles.VRmin,'String'));
    VRmax=str2num(get(handles.VRMax,'String'));
    rngseed=str2num(get(handles.rngseed,'String'));
    levyflight = get(handles.levyflight,'Value') == get(handles.levyflight,'Max');
    
    addpath(handles.path);
    fname =handles.file;
    filename = fname(1:length(fname)-2);
    [data, fit_count, gbest_find, gbestval, worst, std_deviation, Mean, eltime, evalue] = qpso(rngseed, RUNNO,Max_Gen,Particle_Number,Dimension,VRmin,VRmax,levyflight,filename,handles);

    if RUNNO == 1
        % plot(handles.plot, data);
        semilogy(handles.plot, data);
    else
        % plot(handles.plot, mean(data));
        semilogy(handles.plot, mean(data));
    end
    title(handles.plot, 'No of iteration vs mean best fitness values of QPSO Algorithm');
    xlabel(handles.plot, 'No of iterations');
    ylabel(handles.plot, 'Mean of best fitness values');
   
    handles.data = data;
    handles.fit_count = fit_count;
    handles.output_runno = RUNNO;
    handles.evalue = evalue;
    
    set(handles.gbest_find,'String', num2str(gbest_find));
    set(handles.gbest,'String',gbestval);
    set(handles.mean,'String',Mean);
    set(handles.std_deviation,'String',std_deviation);
    set(handles.worst,'String',worst);
    set(handles.eltime,'String',eltime);
    % patch_polyline(gbest_find);
    guidata(hObject,handles);


function runno_Callback(hObject, eventdata, handles)
% hObject    handle to runno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of runno as text
%        str2double(get(hObject,'String')) returns contents of runno as a double


% --- Executes during object creation, after setting all properties.
function runno_CreateFcn(hObject, eventdata, handles)
% hObject    handle to runno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxgen_Callback(hObject, eventdata, handles)
% hObject    handle to maxgen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxgen as text
%        str2double(get(hObject,'String')) returns contents of maxgen as a double


% --- Executes during object creation, after setting all properties.
function maxgen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxgen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function gbest_Callback(hObject, eventdata, handles)
% hObject    handle to gbest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gbest as text
%        str2double(get(hObject,'String')) returns contents of gbest as a double


% --- Executes during object creation, after setting all properties.
function gbest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gbest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function particle_no_Callback(hObject, eventdata, handles)
% hObject    handle to particle_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of particle_no as text
%        str2double(get(hObject,'String')) returns contents of particle_no as a double


% --- Executes during object creation, after setting all properties.
function particle_no_CreateFcn(hObject, eventdata, handles)
% hObject    handle to particle_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dim_Callback(hObject, eventdata, handles)
% hObject    handle to dim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dim as text
%        str2double(get(hObject,'String')) returns contents of dim as a double


% --- Executes during object creation, after setting all properties.
function dim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function VRmin_Callback(hObject, eventdata, handles)
% hObject    handle to VRmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VRmin as text
%        str2double(get(hObject,'String')) returns contents of VRmin as a double


% --- Executes during object creation, after setting all properties.
function VRmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VRmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function VRMax_Callback(hObject, eventdata, handles)
% hObject    handle to VRMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VRMax as text
%        str2double(get(hObject,'String')) returns contents of VRMax as a double


% --- Executes during object creation, after setting all properties.
function VRMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VRMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mean_Callback(hObject, eventdata, handles)
% hObject    handle to mean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mean as text
%        str2double(get(hObject,'String')) returns contents of mean as a double


% --- Executes during object creation, after setting all properties.
function mean_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function std_deviation_Callback(hObject, eventdata, handles)
% hObject    handle to std_deviation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of std_deviation as text
%        str2double(get(hObject,'String')) returns contents of std_deviation as a double


% --- Executes during object creation, after setting all properties.
function std_deviation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to std_deviation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function worst_Callback(hObject, eventdata, handles)
% hObject    handle to worst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of worst as text
%        str2double(get(hObject,'String')) returns contents of worst as a double


% --- Executes during object creation, after setting all properties.
function worst_CreateFcn(hObject, eventdata, handles)
% hObject    handle to worst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)
% hObject    handle to Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uigetfile({'*.m'},'File Selector');
fullpathname = strcat(pathname, filename);
set(handles.display,'String', fullpathname);
handles.file = filename;
handles.path = pathname;
guidata(hObject,handles);



function rngseed_Callback(hObject, eventdata, handles)
% hObject    handle to rngseed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rngseed as text
%        str2double(get(hObject,'String')) returns contents of rngseed as a double


% --- Executes during object creation, after setting all properties.
function rngseed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rngseed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
figure(1);
if handles.output_runno == 1
    % plot(handles.data);
    semilogy(handles.data);
else
    % plot(mean(handles.data));
    semilogy(mean(handles.data));
end
title('No of iteration vs mean best fitness values of QPSO Algorithm');
xlabel('No of iterations');
ylabel('Mean of best fitness values');

% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pause.
function pause_Callback(hObject, eventdata, handles)
% hObject    handle to pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 uiwait

% --- Executes on button press in resume.
function resume_Callback(hObject, eventdata, handles)
% hObject    handle to resume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  uiresume

% --- Executes on button press in restart.
function restart_Callback(hObject, eventdata, handles)
% hObject    handle to restart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  close
  gui


% --- Executes on button press in levyflight.
function levyflight_Callback(hObject, eventdata, handles)
% hObject    handle to levyflight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of levyflight


% --- Executes when selected object is changed in buttongroup.
function buttongroup_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in buttongroup 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
 switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'select_alphamin_alphamax'
        display('Radio button 1');
        set(handles.alphamin,'Enable','on');
        set(handles.alphamax,'Enable','on');
        set(handles.listbox,'Enable','off');
        set(handles.alpha,'Enable','off');
        handles.select = 1;
    case 'select_alpha'
        display('Radio button 2');
        set(handles.listbox,'Enable','on');
        set(handles.alpha,'Enable','on');
        set(handles.alphamin,'Enable','off');
        set(handles.alphamax,'Enable','off');
        handles.select = 2;
 end
guidata(hObject,handles);

function alphamax_Callback(hObject, eventdata, handles)
% hObject    handle to alphamax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alphamax as text
%        str2double(get(hObject,'String')) returns contents of alphamax as a double


% --- Executes during object creation, after setting all properties.
function alphamax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alphamax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox.
function listbox_Callback(hObject, eventdata, handles)
% hObject    handle to listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox
switch get(hObject,'Value')
    case 1
      set(handles.alpha,'Enable','on');
    case 2
      set(handles.alpha,'Enable','off');
    case 3
      set(handles.alpha,'Enable','off');
end


% --- Executes during object creation, after setting all properties.
function listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject,'String',{'Fixed alpha';'0.4 + rand(1,1)/2';'0.5 + 0.5*cos(0.5*pi*current_iteration/max_iteration)'});



function alpha_Callback(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha as text
%        str2double(get(hObject,'String')) returns contents of alpha as a double


% --- Executes during object creation, after setting all properties.
function alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alphamin_Callback(hObject, eventdata, handles)
% hObject    handle to alphamin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alphamin as text
%        str2double(get(hObject,'String')) returns contents of alphamin as a double


% --- Executes during object creation, after setting all properties.
function alphamin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alphamin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in mutation.
function mutation_Callback(hObject, eventdata, handles)
% hObject    handle to mutation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 if get(hObject,'Value') == get(hObject,'Max')
     set(handles.mutation_probability, 'Enable', 'on');
 else
     set(handles.mutation_probability, 'Enable', 'off');
 end

% Hint: get(hObject,'Value') returns toggle state of mutation



function mutation_probability_Callback(hObject, eventdata, handles)
% hObject    handle to mutation_probability (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mutation_probability as text
%        str2double(get(hObject,'String')) returns contents of mutation_probability as a double




% --- Executes during object creation, after setting all properties.
function mutation_probability_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mutation_probability (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fitcount.
function fitcount_Callback(hObject, eventdata, handles)
% hObject    handle to fitcount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(2)
if handles.output_runno==1
    % plot(handles.fit_count(handles.output_runno,:),handles.data);
    semilogy(handles.fit_count(handles.output_runno,:),handles.data);
else
    % plot(handles.fit_count(handles.output_runno,:),mean(handles.data));
    semilogy(handles.fit_count(handles.output_runno,:),mean(handles.data));
end
title('Mean data vs fitness count of QPSO Algorithm');
xlabel('Mean data');
ylabel('Fitness count');



% --- Executes on button press in plot_e.
function plot_e_Callback(hObject, eventdata, handles)
% hObject    handle to plot_e (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

runnumber = str2num(get(handles.runnumber, 'String')); 
iterationnumber = str2num(get(handles.iterationnumber, 'String'));
e = squeeze(handles.evalue(runnumber, iterationnumber, :))';
x = linspace(0,length(e'),length(e'));
figure();
scatter(x,e');
xlabel('No of particles');
ylabel('e value');
title('e value vs No of particles');



function runnumber_Callback(hObject, eventdata, handles)
% hObject    handle to runnumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of runnumber as text
%        str2double(get(hObject,'String')) returns contents of runnumber as a double


% --- Executes during object creation, after setting all properties.
function runnumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to runnumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function iterationnumber_Callback(hObject, eventdata, handles)
% hObject    handle to iterationnumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iterationnumber as text
%        str2double(get(hObject,'String')) returns contents of iterationnumber as a double


% --- Executes during object creation, after setting all properties.
function iterationnumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iterationnumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
