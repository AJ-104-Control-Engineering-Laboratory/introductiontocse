% Apache 2.0 License Control Engineering and Industrial Automation
% Laboratory 2020
% This work is based on  Infernal Rage (2020). Process Control (https://www.mathworks.com/matlabcentral/fileexchange/32501-process-control), MATLAB Central File Exchange. Retrieved October 18, 2020. 

function varargout = simulasip4(varargin)
% SIMULASIP4 M-file for simulasip4.fig
%      SIMULASIP4, by itself, creates a new SIMULASIP4 or raises the existing
%      singleton*.
%
%      H = SIMULASIP4 returns the handle to a new SIMULASIP4 or the handle to
%      the existing singleton*.
%
%      SIMULASIP4('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMULASIP4.M with the given input arguments.
%
%      SIMULASIP4('Property','Value',...) creates a new SIMULASIP4 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simulasip4_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to simulasip4_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simulasip4

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simulasip4_OpeningFcn, ...
                   'gui_OutputFcn',  @simulasip4_OutputFcn, ...
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


% --- Executes just before simulasip4 is made visible.
function simulasip4_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simulasip4 (see VARARGIN)

% Choose default command line output for simulasip4
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global var var1 var2 var3 proportional integral derivative secondorder firstorder vstepAmp figcount stepActive impulseActive
AXE2 = imread('cse.png');
handles.axes2 = image(AXE2);
set(gca,'xtick',[])
set(gca,'ytick',[])
axes(handles.axes1)
x = -100:.1:100;
y = exp(sin(x))-2*cos(4*x)+sin((2*x-pi)/24).^5;
plot(x,y)

grid on
pan on
set(handles.uipanel1, 'SelectedObject', handles.fo);
var = 0;
var1 = 0;
var2 = 0;
var3 = 0;
proportional = 0;
integral = 0;
derivative = 0;
secondorder = 0;
firstorder = 1;
vstepAmp = 1;
figcount = 1;
impulseActive = 2;

% UIWAIT makes simulasip4 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simulasip4_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pc.
function pc_Callback(hObject, eventdata, handles)
% hObject    handle to pc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pc

global proportional var1
if (var1 == 0) 
    proportional = 1;
    var1 = 1;
    y = get(handles.ki, 'String');
    set(handles.txt3, 'String', y);
else
    if (var1 == 1)
        proportional = 0;
        set(handles.kp, 'String', '0')
        var1 = 0;
        set(handles.txt3, 'String', '0');
    end
end
guidata(hObject,handles)

% --- Executes on button press in ii.
function ii_Callback(hObject, eventdata, handles)
% hObject    handle to ii (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ii
axes(handles.axes1)
global firstorder secondorder integral derivative proportional impulseActive stepActive
if (integral == 1)&&(derivative == 1)&&(proportional == 0)
    errordlg('ID controller realization is invalid','ERROR')
else
    k1 = get(handles.k1, 'String');
    vk1 = strread(k1);
    k2 = get(handles.k2, 'String');
    vk2 = strread(k2);
    a = get(handles.a, 'String');
    va = strread(a);
    a1 = get(handles.a1, 'String');
    va1 = strread(a1);
    b = get(handles.b, 'String');
    vb = strread(b);
    b1 = get(handles.b1, 'String');
    vb1 = strread(b1);
    c1 = get(handles.c1, 'String');
    vc1 = strread(c1);
    d1 = get(handles.d1, 'String');
    vd1 = strread(d1);
    kp = get(handles.kp, 'String');
    vkp = strread(kp);
    kd = get(handles.kd, 'String');
    vkd = strread(kd);
    ki = get(handles.ki, 'String');
    vki = strread(ki);
    stepAmp = get(handles.stepA, 'String');
    vstepAmp = strread(stepAmp);
    impulseActive = 1;
    stepActive = 0;
    global secondorder
    if (firstorder == 1)
        n=[(vkd.*vk1) (vkp.*vk1) (vki.*vk1)];
        d=[va vb 0];
        sys=minreal(tf(n,d));
        T = feedback(sys,1);
        impulse(T)
        firstorder = 1;
    else
        firstorder = 0;
    end
    if (secondorder == 1)
        n=[(vd1.*vkd) (vkd.*vk2 + vkp.*vd1) (vki.*vd1 + vkp.*vk2) (vki.*vk2)];
        d=[va1 vb1 vc1 0];
        sys=minreal(tf(n,d));
        T = feedback(sys,1);
        impulse(T)
        secondorder = 1;
    else
        secondorder = 0;
    end
    grid on
end

% --- Executes on button press in si.
function si_Callback(hObject, eventdata, handles)
% hObject    handle to si (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of si
axes(handles.axes1)
global firstorder secondorder integral derivative proportional stepActive impulseActive
if (integral == 1)&&(derivative == 1)&&(proportional == 0)
    errordlg('ID controller realization invalid','ERROR')
else
    k1 = get(handles.k1, 'String');
    vk1 = strread(k1);
    k2 = get(handles.k2, 'String');
    vk2 = strread(k2);
    a = get(handles.a, 'String');
    va = strread(a);
    a1 = get(handles.a1, 'String');
    va1 = strread(a1);
    b = get(handles.b, 'String');
    vb = strread(b);
    b1 = get(handles.b1, 'String');
    vb1 = strread(b1);
    c1 = get(handles.c1, 'String');
    vc1 = strread(c1);
    d1 = get(handles.d1, 'String');
    vd1 = strread(d1);
    kp = get(handles.kp, 'String');
    vkp = strread(kp);
    kd = get(handles.kd, 'String');
    vkd = strread(kd);
    ki = get(handles.ki, 'String');
    vki = strread(ki);
    stepAmp = get(handles.stepA, 'String');
    vstepAmp = strread(stepAmp);
    stepActive = 1;
    impulseActive = 0;
    if (firstorder == 1)
        n=[(vkd.*vk1) (vkp.*vk1) (vki.*vk1)]; d=[va vb 0];
        sys=minreal(tf(n,d));
        T = feedback(sys,1);
        opt = stepDataOptions('InputOffset', 0, 'StepAmplitude', vstepAmp);
        step(T, opt)
        firstorder = 1;
    else
        firstorder = 0;
    end
    if (secondorder == 1)
        n=[(vd1.*vkd) (vkd.*vk2 + vkp.*vd1) (vki.*vd1 + vkp.*vk2) (vki.*vk2)];
        d=[va1 vb1 vc1 0];
        sys=minreal(tf(n,d));
        T = feedback(sys,1);
        opt = stepDataOptions('InputOffset', 0, 'StepAmplitude', vstepAmp);
        step(T, opt)
        secondorder = 1;
    else
        secondorder = 0;
    end
    grid on
end

% --- Executes on button press in ic.
function ic_Callback(hObject, eventdata, handles)
% hObject    handle to ic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ic
global integral var2
if (var2 == 0) 
    integral = 1;
    var2 = 1;
    y = get(handles.ki, 'String');
    set(handles.txt5, 'String', y);
else
    if (var2 == 1)
        integral = 0;
        set(handles.ki, 'String', '0')
        var2 = 0;
        set(handles.txt5, 'String', '0');
    end
end
guidata(hObject,handles)

% --- Executes on button press in dc.
function dc_Callback(hObject, eventdata, handles)
% hObject    handle to dc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dc
global derivative var3
if (var3 == 0)
    derivative = 1;
    var3 = 1;
    y = get(handles.ki, 'String');
    set(handles.txt4, 'String', y);
else
    if (var3 == 1)
        derivative = 0;
        set(handles.kd, 'String', '0')
        var3 = 0;
        set(handles.txt4, 'String', '0');
    end
end
guidata(hObject,handles)

% --- Executes on button press in fo.
function fo_Callback(hObject, eventdata, handles)
% hObject    handle to fo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fo

% --- Executes on button press in so.
function so_Callback(hObject, eventdata, handles)
% hObject    handle to so (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of so

% --- Executes on button press in grid.
function grid_Callback(hObject, eventdata, handles)
% hObject    handle to grid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global var
axes(handles.axes1);
if (var == 0) 
    grid on
    var = 1;
else
    if (var == 1)
        grid off
        var = 0;
    end
end

% --- Executes on button press in zo.
function zo_Callback(hObject, eventdata, handles)
% hObject    handle to zo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
zoom(0.9)

% --- Executes on button press in zi.
function zi_Callback(hObject, eventdata, handles)
% hObject    handle to zi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1)
zoom(1.1)



function k1_Callback(hObject, eventdata, handles)
% hObject    handle to k1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k1 as text
%        str2double(get(hObject,'String')) returns contents of k1 as a double
global firstorder
x = str2double(get(hObject, 'String'));
if isnan(x)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
y = num2str(x);
set(handles.txt1,'String',y)
if (firstorder ~= 1)
    errordlg('Error')
    set(handles.k1, 'String', '0')
    set(handles.txt1,'String','0')
    firstorder = 0;
end

% --- Executes during object creation, after setting all properties.
function k1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a_Callback(hObject, eventdata, handles)
% hObject    handle to a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a as text
%        str2double(get(hObject,'String')) returns contents of a as a double
global firstorder
x = str2double(get(hObject, 'String'));
if isnan(x)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
y = num2str(x);
set(handles.txt6,'String',y)
if (firstorder ~= 1)
    errordlg('Error')
    set(handles.a, 'String', '0')
    set(handles.txt6,'String','0')
    firstorder = 0;
end

% --- Executes during object creation, after setting all properties.
function a_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function b_Callback(hObject, eventdata, handles)
% hObject    handle to b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of b as text
%        str2double(get(hObject,'String')) returns contents of b as a double
global firstorder
x = str2double(get(hObject, 'String'));
if isnan(x)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
y = num2str(x);
set(handles.txt7,'String',y)
if (firstorder ~= 1)
    errordlg('Error')
    set(handles.b, 'String', '0')
    set(handles.txt7,'String','0')
    firstorder = 0;
end

% --- Executes during object creation, after setting all properties.
function b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kd_Callback(hObject, eventdata, handles)
% hObject    handle to kd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kd as text
%        str2double(get(hObject,'String')) returns contents of kd as a double
global derivative 
x = str2double(get(hObject, 'String'));
if isnan(x)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
y = num2str(x);
set(handles.txt4,'String',y)
if (derivative ~= 1)
    errordlg('Error')
    set(handles.kd, 'String', '0')
    set(handles.txt4,'String','0')
    derivative = 0;
end

% --- Executes during object creation, after setting all properties.
function kd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ki_Callback(hObject, eventdata, handles)
% hObject    handle to ki (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ki as text
%        str2double(get(hObject,'String')) returns contents of ki as a double
global integral 
x = str2double(get(hObject, 'String'));
if isnan(x)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
y = num2str(x);
set(handles.txt5,'String',y)
if (integral ~= 1)
    errordlg('Error')
    set(handles.ki, 'String', '0')
    set(handles.txt5,'String','0')
    integral = 0;
end

% --- Executes during object creation, after setting all properties.
function ki_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ki (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kp_Callback(hObject, eventdata, handles)
% hObject    handle to kp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kp as text
%        str2double(get(hObject,'String')) returns contents of kp as a double
global proportional
x = str2double(get(hObject, 'String'));
if isnan(x)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
y = num2str(x);
set(handles.txt3,'String',y)
if (proportional ~= 1)
    errordlg('Error')
    set(handles.kp, 'String', '0')
    set(handles.txt3,'String','0')
    proportional = 0;
end

% --- Executes during object creation, after setting all properties.
function kp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k2_Callback(hObject, eventdata, handles)
% hObject    handle to k2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k2 as text
%        str2double(get(hObject,'String')) returns contents of k2 as a double
global secondorder
x = str2double(get(hObject, 'String'));
if isnan(x)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
y = num2str(x);
set(handles.txt1,'String',y)
if (secondorder ~= 1)
    errordlg('Error')
    set(handles.k2, 'String', '0')
    set(handles.txt1,'String','0')
    secondorder = 0;
end

% --- Executes during object creation, after setting all properties.
function k2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a1_Callback(hObject, eventdata, handles)
% hObject    handle to a1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a1 as text
%        str2double(get(hObject,'String')) returns contents of a1 as a double
global secondorder
x = str2double(get(hObject, 'String'));
if isnan(x)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
y = num2str(x);
set(handles.txt2,'String',y)
if (secondorder ~= 1)
    errordlg('Error')
    set(handles.a1, 'String', '0')
    set(handles.txt2,'String','0')
    secondorder = 0;
end
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function a1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function b1_Callback(hObject, eventdata, handles)
% hObject    handle to b1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of b1 as text
%        str2double(get(hObject,'String')) returns contents of b1 as a double
global secondorder
x = str2double(get(hObject, 'String'));
if isnan(x)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
y = num2str(x);
set(handles.txt6,'String',y)
if (secondorder ~= 1)
    errordlg('Error')
    set(handles.b1, 'String', '0')
    set(handles.txt6,'String','0')
    secondorder = 0;
end

% --- Executes during object creation, after setting all properties.
function b1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to b1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c1_Callback(hObject, eventdata, handles)
% hObject    handle to c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c1 as text
%        str2double(get(hObject,'String')) returns contents of c1 as a double
global secondorder
x = str2double(get(hObject, 'String'));
if isnan(x)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
y = num2str(x);
set(handles.txt7,'String',y)
if (secondorder ~= 1)
    errordlg('Error')
    set(handles.c1, 'String', '0')
    set(handles.txt7,'String','0')
    secondorder = 0;
end


% --- Executes during object creation, after setting all properties.
function c1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

global firstorder secondorder
if (hObject == handles.fo)
    set(handles.k2, 'String', '0');
    set(handles.a1, 'String', '0');
    set(handles.b1, 'String', '0');
    set(handles.c1, 'String', '0');
    firstorder = 1;
    secondorder = 0;
    set(handles.txt1, 'String', '0');
    set(handles.txt2, 'String', '0');
    set(handles.txt6, 'String', '0');
    set(handles.txt7, 'String', '0');
else
    set(handles.k1, 'String', '0');
    set(handles.a, 'String', '0');
    set(handles.b, 'String', '0');
    firstorder = 0;
    secondorder = 1;
    set(handles.txt1, 'String', '0');
    set(handles.txt2, 'String', '0');
    set(handles.txt7, 'String', '0');
    set(handles.txt6, 'String', '0');
end

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3



function d1_Callback(hObject, eventdata, handles)
% hObject    handle to d1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of d1 as text
%        str2double(get(hObject,'String')) returns contents of d1 as a double
global secondorder
x = str2double(get(hObject, 'String'));
if isnan(x)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
y = num2str(x);
set(handles.txt7,'String',y)
if (secondorder ~= 1)
    errordlg('Error')
    set(handles.d1, 'String', '0')
    set(handles.txt7,'String','0')
    secondorder = 0;
end

% --- Executes during object creation, after setting all properties.
function d1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to d1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stepA_Callback(hObject, eventdata, handles)
% hObject    handle to stepA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stepA as text
%        str2double(get(hObject,'String')) returns contents of stepA as a double
global secondorder
x = str2double(get(hObject, 'String'));
if isnan(x)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
y = num2str(x);
set(handles.txt7,'String',y)
if (secondorder ~= 1)
    errordlg('Error')
    set(handles.stepA, 'String', '0')
    set(handles.txt7,'String','0')
    secondorder = 0;
end

% --- Executes during object creation, after setting all properties.
function stepA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stepA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%2. Copy axes to new figure and save
global figcount impulseActive
switch impulseActive
    case 1
        filename = 'impulseresponse';
    case 0
        filename = 'stepresponse';
    case 2
        warndlg('Please Simulate The System First!');
        filename = 'base';
end
extension ='.fig';
outputFileName = strcat(filename, num2str(figcount), extension);
fignew = figure('Visible','off'); % Invisible figure
newAxes = copyobj(handles.axes1,fignew); % Copy the appropriate axes
set(newAxes,'Position',get(groot,'DefaultAxesPosition')); % The original position is copied too, so adjust it.
set(fignew,'CreateFcn','set(gcbf,''Visible'',''on'')'); % Make it visible upon loading
savefig(fignew,outputFileName);
figcount = figcount + 1;
delete(fignew);