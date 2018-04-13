function varargout = DSAA(varargin)
% DSAA MATLAB code for DSAA.fig
%      DSAA, by itself, creates a new DSAA or raises the existing
%      singleton*.
%
%      H = DSAA returns the handle to a new DSAA or the handle to
%      the existing singleton*.
%
%      DSAA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DSAA.M with the given input arguments.
%
%      DSAA('Property','Value',...) creates a new DSAA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DSAA_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DSAA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DSAA

% Last Modified by GUIDE v2.5 19-Nov-2017 03:08:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DSAA_OpeningFcn, ...
                   'gui_OutputFcn',  @DSAA_OutputFcn, ...
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


% --- Executes just before DSAA is made visible.
function DSAA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DSAA (see VARARGIN)

% Choose default command line output for DSAA
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DSAA wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DSAA_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
recObj = audiorecorder;
disp('Start speaking')
recordblocking(recObj, 5);
disp('End of Recording');
handles.metricdata.x = getaudiodata(recObj);
handles.metricdata.mu = 0.00157;
guidata(hObject,handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.metricdata.y = zeros(size(handles.metricdata.x));
handles.metricdata.y(1:2000) = handles.metricdata.x(1:2000);
for i = 2001:length(handles.metricdata.x)
    handles.metricdata.y(i) = handles.metricdata.x(i) + 0.05*handles.metricdata.x(i-2000);
end;
guidata(hObject,handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.metricdata.N = size(handles.metricdata.y);
handles.metricdata.w = zeros(handles.metricdata.N);
handles.metricdata.e = zeros(handles.metricdata.N);
for i = 1:handles.metricdata.N
    if(i ~= 1)
        handles.metricdata.w(i) = handles.metricdata.w(i-1) + 2*handles.metricdata.mu*handles.metricdata.e(i-1)*handles.metricdata.y(i-1);
    end;
    handles.metricdata.z(i) = handles.metricdata.w'*handles.metricdata.y;
    handles.metricdata.e(i) = handles.metricdata.x(i) - handles.metricdata.z(i);
end;
handles.metricdata.z = (handles.metricdata.z).* 10^(5/20);
guidata(hObject,handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.metricdata.N = size(handles.metricdata.y);
handles.metricdata.w1 = zeros(handles.metricdata.N);
handles.metricdata.e1 = zeros(handles.metricdata.N);
handles.metricdata.mu1 = handles.metricdata.mu;
for i = 1:handles.metricdata.N
    if(i ~= 1)
        handles.metricdata.w1(i) = handles.metricdata.w1(i-1) + handles.metricdata.mu1*handles.metricdata.e1(i-1)*handles.metricdata.y(i-1);
    end;
    handles.metricdata.z1(i) = (handles.metricdata.w1'*handles.metricdata.y);
    handles.metricdata.mu1 = 1/(handles.metricdata.y(1:i)'*handles.metricdata.y(1:i)+1000);
    handles.metricdata.e1(i) = handles.metricdata.x(i) - handles.metricdata.z1(i);
end;
handles.metricdata.z1 = (handles.metricdata.z1).* 10^(5/20);
guidata(hObject,handles);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sound(handles.metricdata.x);
guidata(hObject,handles);


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sound(handles.metricdata.z);
guidata(hObject,handles);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sound(handles.metricdata.y);
guidata(hObject,handles);


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sound(handles.metricdata.z1);
guidata(hObject,handles);



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
handles.metricdata.mu = str2num(get(handles.edit2,'String'));
guidata(hObject,handles);
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
subplot(2, 2, 1);
plot(handles.metricdata.x);
xlabel('Seconds');
ylabel('Sound');
title('Input Signal');
subplot(2, 2, 2);
plot(handles.metricdata.y);
xlabel('Seconds');
ylabel('Sound');
title('Echoed Signal');
subplot(2, 2, 3);
plot(handles.metricdata.z);
xlabel('Seconds');
ylabel('Sound');
title('Obtained Signal by LMS');
subplot(2, 2, 4);
plot(handles.metricdata.e);
xlabel('Seconds');
ylabel('Sound');
title('Error Signal');
guidata(hObject,handles);


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2);
subplot(2, 2, 1);
plot(handles.metricdata.x);
xlabel('Seconds');
ylabel('Sound');
title('Input Signal');
subplot(2, 2, 2);
plot(handles.metricdata.y);
xlabel('Seconds');
ylabel('Sound');
title('Echoed Signal');
subplot(2, 2, 3);
plot(handles.metricdata.z1);
xlabel('Seconds');
ylabel('Sound');
title('Obtained Signal by NLMS');
subplot(2, 2, 4);
plot(handles.metricdata.e1);
xlabel('Seconds');
ylabel('Sound');
title('Error Signal');
guidata(hObject,handles);
