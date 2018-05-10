function varargout = GUI(varargin)
clc
% GUI MATLAB code for GUI.fig
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
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 22-Apr-2018 22:54:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in runbutton.
function runbutton_Callback(hObject, eventdata, handles)
% hObject    handle to runbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% MALHA

inp.DELTA_X=str2num(get(handles.deltax,'String'));
inp.DELTA_T=str2num(get(handles.deltat,'String'));

%% EQ_TYPE

conv=get(handles.conv,'Value');
if conv==1
    inp.EQ_TYPE=2;
else 
    inp.EQ_TYPE=1;
end

inp.A=str2num(get(handles.velocidade,'String'));

%% CONDICAO INICIAL

check(1)=get(handles.quad10,'Value');
check(2)=get(handles.sen,'Value');
check(3)=get(handles.ps,'Value');
check(4)=get(handles.p,'Value');
check(5)=get(handles.quad010,'Value');
check(6)=get(handles.quad21,'Value');
check(7)=get(handles.quad212,'Value');

check(8)=get(handles.analytical,'Value');

for i=1:7
   if check(i)==1
       inp.IC=i;
       i=8;
   end
end

%% PARAMETROS ENO/WENO

inp.TOTAL_POINTS=str2num(get(handles.totalpoints,'String'));

%% FILTRO

filtro=get(handles.filtro,'Value');
if filtro==1
    inp.FILTER=6;
else 
    inp.FILTER=0;
end

ALPHA=str2num(get(handles.alpha,'String'));

%% METHOD e CALCULOS

q=zeros(6,1);
q(1)=get(handles.checkweno,'Value'); 
q(2)=get(handles.checkeno,'Value'); 
q(3)=get(handles.checkcompacto,'Value'); 
q(4)=get(handles.checkcentrado,'Value'); 
q(5)=get(handles.checkupfow,'Value'); 
q(6)=get(handles.checkupbac,'Value');

flag=[0 0 0 0 0 0];
number=0;
j=1;
% dbstop if error
for i=1:2
    if q(i)==1
        flag(i)=1;
        inp.METHOD=i;
        number=number+1;
        local_y{j}=num2str(i);
        j=j+1;
        weno_gui
    end
end

for i=3:6
    if q(i)==1
        flag(i)=0;
        inp.METHOD=i;
        number=number+1;
        local_y{j}=num2str(i);
        j=j+1;
        codigo_gui
    end
end

g_code{1}='go-';
g_code{2}='ro-';
g_code{3}='mo-';
g_code{4}='co-';
g_code{5}='yo-';
g_code{6}='bo-';
g_code{7}='wo-';

if check(8)==1 && inp.EQ_TYPE==2
   analytical=1; 
elseif check(8) == 0 && inp.EQ_TYPE==2
    analytical=0;
end
   
if check(8)==1 && inp.EQ_TYPE==1 && inp.IC==4
   analytical_burgers=1; 
else
    analytical_burgers=0;
end


comparison_gui




% --- Executes on button press in animate.
function animate_Callback(hObject, eventdata, handles)
% hObject    handle to animate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

q=zeros(6,1);
q(1)=get(handles.checkweno,'Value'); 
q(2)=get(handles.checkeno,'Value'); 
q(3)=get(handles.checkcompacto,'Value'); 
q(4)=get(handles.checkcentrado,'Value'); 
q(5)=get(handles.checkupfow,'Value'); 
q(6)=get(handles.checkupbac,'Value');

flag=[0 0 0 0 0 0];
number=0;
j=1;
% dbstop if error
for i=1:2
    if q(i)==1
        flag(i)=1;
        inp.METHOD=i;
        number=number+1;
        local_y{j}=num2str(i);
        j=j+1;
        
    end
end

for i=3:6
    if q(i)==1
        flag(i)=0;
        inp.METHOD=i;
        number=number+1;
        local_y{j}=num2str(i);
        j=j+1;
       
    end
end

g_code{1}='wo-';
g_code{2}='go-';
g_code{3}='ro-';
g_code{4}='mo-';
g_code{5}='co-';
g_code{6}='yo-';
g_code{7}='bo-';

comparacao_gui

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


% --- Executes on button press in filtro.
function filtro_Callback(hObject, eventdata, handles)
% hObject    handle to filtro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filtro

filtro=get(handles.filtro,'Value');
if filtro==1
    inp.FILTER=6;
else 
    inp.FILTER=0;
end



function totalpoints_Callback(hObject, eventdata, handles)
% hObject    handle to totalpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of totalpoints as text
%        str2double(get(hObject,'String')) returns contents of totalpoints as a double


% --- Executes during object creation, after setting all properties.
function totalpoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to totalpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in quad10.
function quad10_Callback(hObject, eventdata, handles)
% hObject    handle to quad10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of quad10
set(handles.sen,'Value',0);
set(handles.ps,'Value',0);
set(handles.p,'Value',0);
set(handles.quad010,'Value',0);
set(handles.quad21,'Value',0);
set(handles.quad212,'Value',0);

x=linspace(-1,1,200);
plot(x,initial_condition(x,1),'LineWidth',5)


% --- Executes on button press in sen.
function sen_Callback(hObject, eventdata, handles)
% hObject    handle to sen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sen
set(handles.quad10,'Value',0);
set(handles.ps,'Value',0);
set(handles.p,'Value',0);
set(handles.quad010,'Value',0);
set(handles.quad21,'Value',0);
set(handles.quad212,'Value',0);

x=linspace(-1,1,200);
plot(x,initial_condition(x,2),'LineWidth',5)

% --- Executes on button press in ps.
function ps_Callback(hObject, eventdata, handles)
% hObject    handle to ps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ps
set(handles.quad10,'Value',0);
set(handles.sen,'Value',0);
set(handles.p,'Value',0);
set(handles.quad010,'Value',0);
set(handles.quad21,'Value',0);
set(handles.quad212,'Value',0);

x=linspace(-1,1,200);
plot(x,initial_condition(x,3),'LineWidth',5)

% --- Executes on button press in p.
function p_Callback(hObject, eventdata, handles)
% hObject    handle to p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of p
set(handles.quad10,'Value',0);
set(handles.sen,'Value',0);
set(handles.ps,'Value',0);
set(handles.quad010,'Value',0);
set(handles.quad21,'Value',0);
set(handles.quad212,'Value',0);

x=linspace(-1,1,200);
plot(x,initial_condition(x,4),'LineWidth',5)


% --- Executes on button press in quad010.
function quad010_Callback(hObject, eventdata, handles)
% hObject    handle to quad010 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of quad010
set(handles.quad10,'Value',0);
set(handles.sen,'Value',0);
set(handles.ps,'Value',0);
set(handles.p,'Value',0);
set(handles.quad21,'Value',0);
set(handles.quad212,'Value',0);

x=linspace(-1,1,200);
plot(x,initial_condition(x,5),'LineWidth',5)

% --- Executes on button press in quad21.
function quad21_Callback(hObject, eventdata, handles)
% hObject    handle to quad21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of quad21
set(handles.quad10,'Value',0);
set(handles.sen,'Value',0);
set(handles.ps,'Value',0);
set(handles.p,'Value',0);
set(handles.quad010,'Value',0);
set(handles.quad212,'Value',0);

x=linspace(-1,1,200);
plot(x,initial_condition(x,6),'LineWidth',5)

% --- Executes on button press in quad212.
function quad212_Callback(hObject, eventdata, handles)
% hObject    handle to quad212 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of quad212
set(handles.quad10,'Value',0);
set(handles.sen,'Value',0);
set(handles.ps,'Value',0);
set(handles.p,'Value',0);
set(handles.quad010,'Value',0);
set(handles.quad21,'Value',0);

x=linspace(-1,1,200);
plot(x,initial_condition(x,7),'LineWidth',5)


% --- Executes on button press in conv.
function conv_Callback(hObject, eventdata, handles)
% hObject    handle to conv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of conv

set(handles.burgers,'Value',0);
set(handles.analytical,'Visible','on');

function velocidade_Callback(hObject, eventdata, handles)
% hObject    handle to velocidade (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of velocidade as text
%        str2double(get(hObject,'String')) returns contents of velocidade as a double


% --- Executes during object creation, after setting all properties.
function velocidade_CreateFcn(hObject, eventdata, handles)
% hObject    handle to velocidade (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in burgers.
function burgers_Callback(hObject, eventdata, handles)
% hObject    handle to burgers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of burgers
set(handles.conv,'Value',0);

% --- Executes on button press in checkweno.
function checkweno_Callback(hObject, eventdata, handles)
% hObject    handle to checkweno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkweno
v1=get(handles.checkweno,'Value');
v2=get(handles.checkeno,'Value');
if v1==1||v2==1
    set(handles.para1,'Visible','on')
else 
    set(handles.para1,'Visible','off')
end

% --- Executes on button press in checkeno.
function checkeno_Callback(hObject, eventdata, handles)
% hObject    handle to checkeno (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkeno
v1=get(handles.checkweno,'Value');
v2=get(handles.checkeno,'Value');
if v1==1||v2==1
    set(handles.para1,'Visible','on')
else 
    set(handles.para1,'Visible','off')
end


% --- Executes on button press in checkcompacto.
function checkcompacto_Callback(hObject, eventdata, handles)
% hObject    handle to checkcompacto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkcompacto
c1=get(handles.checkcompacto,'Value');
c2=get(handles.checkcentrado,'Value');
c3=get(handles.checkupfow,'Value');
c4=get(handles.checkupbac,'Value');

if c1==1||c2==1||c3==1||c4==1
    set(handles.para2,'Visible','on');
else
    set(handles.para2,'Visible','off');
end

% --- Executes on button press in checkcentrado.
function checkcentrado_Callback(hObject, eventdata, handles)
% hObject    handle to checkcentrado (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkcentrado
c1=get(handles.checkcompacto,'Value');
c2=get(handles.checkcentrado,'Value');
c3=get(handles.checkupfow,'Value');
c4=get(handles.checkupbac,'Value');

if c1==1||c2==1||c3==1||c4==1
    set(handles.para2,'Visible','on');
else
    set(handles.para2,'Visible','off');
end

% --- Executes on button press in checkupfow.
function checkupfow_Callback(hObject, eventdata, handles)
% hObject    handle to checkupfow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkupfow
c1=get(handles.checkcompacto,'Value');
c2=get(handles.checkcentrado,'Value');
c3=get(handles.checkupfow,'Value');
c4=get(handles.checkupbac,'Value');

if c1==1||c2==1||c3==1||c4==1
    set(handles.para2,'Visible','on');
else
    set(handles.para2,'Visible','off');
end

% --- Executes on button press in checkupbac.
function checkupbac_Callback(hObject, eventdata, handles)
% hObject    handle to checkupbac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkupbac
c1=get(handles.checkcompacto,'Value');
c2=get(handles.checkcentrado,'Value');
c3=get(handles.checkupfow,'Value');
c4=get(handles.checkupbac,'Value');

if c1==1||c2==1||c3==1||c4==1
    set(handles.para2,'Visible','on');
else
    set(handles.para2,'Visible','off');
end


function deltax_Callback(hObject, eventdata, handles)
% hObject    handle to deltax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltax as text
%        str2double(get(hObject,'String')) returns contents of deltax as a double


% --- Executes during object creation, after setting all properties.
function deltax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function deltat_Callback(hObject, eventdata, handles)
% hObject    handle to deltat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltat as text
%        str2double(get(hObject,'String')) returns content  s of deltat as a double


% --- Executes during object creation, after setting all properties.
function deltat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in analytical.
function analytical_Callback(hObject, eventdata, handles)
% hObject    handle to analytical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of analytical


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
