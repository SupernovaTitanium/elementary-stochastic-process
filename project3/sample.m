function varargout = sample(varargin)
% SAMPLE MATLAB code for sample.fig
%      SAMPLE, by itself, creates a new SAMPLE or raises the existing
%      singleton*.
%
%      H = SAMPLE returns the handle to a new SAMPLE or the handle to
%      the existing singleton*.
%
%      SAMPLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAMPLE.M with the given input arguments.
%
%      SAMPLE('Property','Value',...) creates a new SAMPLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sample_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sample_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sample

% Last Modified by GUIDE v2.5 15-Jun-2015 08:11:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sample_OpeningFcn, ...
                   'gui_OutputFcn',  @sample_OutputFcn, ...
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

% --- Executes just before sample is made visible.
function sample_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sample (see VARARGIN)

% Choose default command line output for sample
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using sample.
if strcmp(get(hObject,'Visible'),'off')  %initial axis
   
end

% UIWAIT makes sample wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sample_OutputFcn(hObject, eventdata, handles)
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
%clear axes
cla;
rng('shuffle');
%load data from file 
data=load(get(handles.browsepath, 'String'))
data_len=length(data);
dataloop=[];
ksy=[];
ksx=[];
%select list 
popup_sel_index = get(handles.popupmenu1, 'Value');
switch popup_sel_index
    case 1   %gaussian
                pd=makedist('Normal',0,1);
    case 2   %exponential
                pd=makedist('Exponential',1);
    case 3   %logistic
                pd=makedist('Logistic',0,1);
end
  for i=1:data_len
             data_loop=data(1:i);
             %plot data and distribution
             if mod(i,100) == 0
                 axes(handles.graph1);
                 set(gca,'FontSize',10);
                 [f,x] = ecdf(data_loop);
                 plot(x,f);
                 axis([-inf,inf,0,1]);
                 hold on
                 xaxis= min(x):.01:max(x);
                 yaxis=cdf(pd,xaxis);
                 plot(xaxis,yaxis,'g-','LineWidth',2);
                 legend('data','cdf','Location','northwest','Orientation','horizontal');
                 title(sprintf('Iteration: %d', i));
                 hold off
                 %plot ks test 
                 axes(handles.graph2);
                 set(gca,'FontSize',10);
                 [ks1,ks2,ks3,ks4] = kstest(data(1:i),'CDF',pd,'Alpha',0.01);
                 ksy=[ksy ks3];
                 ksx=[ksx i]; 
                 axis([1,i,0,1]);
                 plot(ksx,ksy);
                 legend('ks-static','Location','northwest','Orientation','horizontal'); 
                 title(sprintf('Iteration: %d Kstatic: %f', i,ks3));
                 drawnow;              
             end
        end      
    



% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'Gaussian', 'Exponential', 'Logistic'});


% --- Executes during object creation, after setting all properties.
function graph1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to graph1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate graph1


% --- Executes on mouse press over graph1 background.
function graph1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to graph1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object deletion, before destroying properties.
function graph1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to graph1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,FilePath]=uigetfile({'*.*'},'File Selector');
ExPath = [FilePath FileName];
set(handles.browsepath,'String',ExPath);
guidata(hObject, handles);


% --- Executes on button press in browsepath.
function browsepath_Callback(hObject, eventdata, handles)
% hObject    handle to browsepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
