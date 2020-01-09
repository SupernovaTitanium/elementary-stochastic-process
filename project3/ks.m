function varargout = ks(varargin)
% KS MATLAB code for ks.fig
%      KS, by itself, creates a new KS or raises the existing
%      singleton*.
%
%      H = KS returns the handle to a new KS or the handle to
%      the existing singleton*.
%
%      KS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KS.M with the given input arguments.
%
%      KS('Property','Value',...) creates a new KS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ks_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ks_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ks

% Last Modified by GUIDE v2.5 18-Jun-2015 00:34:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ks_OpeningFcn, ...
                   'gui_OutputFcn',  @ks_OutputFcn, ...
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

% --- Executes just before ks is made visible.
function ks_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ks (see VARARGIN)

% Choose default command line output for ks
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using ks.
if strcmp(get(hObject,'Visible'),'off')  %initial axis
   
end

% UIWAIT makes ks wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ks_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
function samplepopup_CreateFcn(hObject, eventdata, handles)
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%clear axes
cla;
rng('shuffle');
%load data from file 
data=load(get(handles.browsepath, 'String'));
data_len=length(data);
dataloop=[];
ksy=[];
ksx=[];
%paremeter seting
p1 = 0;
p2 = 1;
speed = str2double(get(handles.speed,'String'));
%select list 
popup_sel_index = get(handles.popupmenu1, 'Value');
switch popup_sel_index
    case 1   %Uniform
                pd=makedist('Uniform',p1,p2);
    case 2   %Normal
                pd=makedist('Normal',p1,p2);
end
axes(handles.graph1);
  for i=1:data_len
             data_loop=data(1:i);
             %plot data and distribution
             if mod(i,speed) == 0 %iteration increment
                 
                 [f,x] = ecdf(data_loop);
                 cdfplot(x);
                 hold on
                 xaxis= min(x):.01:max(x);
                 yaxis=cdf(pd,xaxis);
                 plot(xaxis,yaxis,'g-','LineWidth',2)
                 hold off
                 legend('data','cdf','Location','northwest','Orientation','horizontal');
                 title(sprintf('Iteration: %d', i));
                 %plot ks test 
                 [ks1,ks2,ks3,ks4] = kstest(data(1:i),'CDF',pd,'Alpha',0.01);
                 ksy=[ksy ks3];
                 ksx=[ksx i]; 
                 plot(handles.graph2,ksx,ksy,'r-','LineWidth',2);
                 legend(handles.graph2,'ks-static','Location','Northeast','Orientation','horizontal'); 
                 title(handles.graph2,sprintf('Iteration: %d Kstatic: %f', i,ks3));
                 drawnow;         
             end
        end      
 guidata(hObject, handles);   




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

set(hObject, 'String', {'Uniform(0,1)', 'Normal(0,1)'});


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




% --- Executes during object creation, after setting all properties.
function pushbutton1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function speed_Callback(hObject, eventdata, handles)
% hObject    handle to speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of speed as text
%        str2double(get(hObject,'String')) returns contents of speed as a double
input = str2num(get(hObject,'String'));
if (isempty(input))
     set(hObject,'String','100');
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function graph2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to graph2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate graph2


% --- Executes during object deletion, before destroying properties.
function graph2_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to graph2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function graph2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to graph2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in pop1.
function pop1_Callback(hObject, eventdata, handles)
% hObject    handle to pop1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop1


% --- Executes during object creation, after setting all properties.
function pop1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'String', {'Uniform(0,1)', 'Normal(0,1)'});


% --- Executes on button press in pairempirical.
function pairempirical_Callback(hObject, eventdata, handles)
% hObject    handle to pairempirical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rng('shuffle');
hold off;
%paremeter seting
p1 = 0;
p2 = 1;
speed = str2double(get(handles.speed,'String'));
%select list 
popup_dis_index = get(handles.popupmenu1, 'Value');
axes(handles.pempfg);
switch popup_dis_index
    case 1   %Uniform
                pd=makedist('Uniform','Lower',p1,'Upper',p2);
                axis([p1,p2,0,1.0]);
                xaxis= p1:.01:p2;
                yaxis=cdf(pd,xaxis);
    case 2   %Normal
                pd=makedist('Normal',p1,p2);
                axis([(p1-4*p2),(p1+4*p2),0,1.0]);
                xaxis= p1-4*p2:.01:p1+4*p2;
                yaxis=cdf(pd,xaxis);
end
popup_sam_index = get(handles.pop1, 'Value');
switch popup_sam_index
     case 1   %uniform
                sam_pd=makedist('Uniform','Lower',p1,'Upper',p2);
     case 2   %Normal
                sam_pd=makedist('Normal',p1,p2);
end
set(handles.pairempirical,'UserData',0);
% define cdf maybe later move to case
for n=1:10000
                     if(get(handles.pairempirical,'UserData')==1)
                     break;                         
                     end
                     if mod(n,speed)==0
                     rng('shuffle');
                     dataloop=random(sam_pd,n,1);
                     cdfplot(dataloop);
                     hold on
                     grid off
                     plot(handles.pempfg,xaxis,yaxis,'g-','LineWidth',2);
                     legend(handles.pempfg,'empirical cdf','cdf','Location','northwest','Orientation','horizontal');
                     title(handles.pempfg,sprintf('Sample size: %d ', n),'Fontsize',15);
                     drawnow;
                     hold off
                     end
 end                 
                   
            
   
 guidata(hObject, handles); 
% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pairempirical,'UserData',1);
guidata(hObject, handles);


% --- Executes on button press in stop2.
function stop2_Callback(hObject, eventdata, handles)
% hObject    handle to stop2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.emppx,'UserData',1);
guidata(hObject, handles);

% --- Executes on button press in emppx.
function emppx_Callback(hObject, eventdata, handles)
rng('shuffle');
hold off;
%paremeter seting
p1 = 0;
p2 = 1;
speed = str2double(get(handles.speed,'String'));
x_of_interest=str2double(get(handles.fixx,'String'));
num=str2double(get(handles.emp_num,'String'));
%select list 
popup_sam_index = get(handles.pop1, 'Value');
switch popup_sam_index
     case 1   %uniform
                sam_pd=makedist('Uniform','Lower',p1,'Upper',p2);
     case 2   %Normal
                sam_pd=makedist('Normal',p1,p2);
end
f_x=cdf(sam_pd,x_of_interest);
var=f_x*(1-f_x);
sd=var^0.5;
pd=makedist('Normal',0,sd);
axis=([-4*sd,4*sd,0,1]);
xaxis= (-4*sd):.001:(4*sd);
yaxis=cdf(pd,xaxis);
set(handles.emppx,'UserData',0);
% define cdf maybe later move to case
forz=zeros(1,num);
for n=1:10000
                     if(get(handles.emppx,'UserData')==1)
                     break;                         
                     end
                     if mod(n,speed)==0                 
                     x_interest=forz;
                     for k=1:num
                     %producing different f^_n
                     x=random(sam_pd,n,1);
                     e=sum(x<x_of_interest)/n;                                                             
                     emp=(n^0.5)*(e-f_x);
                     x_interest(k)=emp;
                     end
                     [e_f,e_x]=ecdf(x_interest);
                     plot(handles.empp,e_x,e_f,xaxis,yaxis);                     
                     legend(handles.empp,'empirical process at x',sprintf('N(0,%f)',var),'Location','northwest','Orientation','horizontal');
                     title(handles.empp,sprintf('Sample size: %d Num of emp: %d  F(x=%f)=%f  Converge to N(0,%f)', n,num,x_of_interest,f_x,var),'Fontsize',12);  
                     drawnow;
                     end
                                          
end 
 guidata(hObject, handles);  



function emp_num_Callback(hObject, eventdata, handles)
% hObject    handle to emp_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of emp_num as text
%        str2double(get(hObject,'String')) returns contents of emp_num as a double
input = str2num(get(hObject,'String'));
if (isempty(input))
     set(hObject,'String','1000');
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function emp_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to emp_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fixx_Callback(hObject, eventdata, handles)
% hObject    handle to fixx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fixx as text
%        str2double(get(hObject,'String')) returns contents of fixx as a double
input = str2num(get(hObject,'String'));
if (isempty(input))
     set(hObject,'String','0.5');
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function fixx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in empbb.
function empbb_Callback(hObject, eventdata, handles)
% hObject    handle to empbb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rng('shuffle');
axes(handles.bb);
cla;
%paremeter seting
p1 =0;
p2 =1;
observe=str2double(get(handles.fixx,'String'));
%select list 
popup_sam_index = get(handles.pop1, 'Value');
switch popup_sam_index
     case 1   %uniform
                sam_pd=makedist('Uniform','Lower',p1,'Upper',p2);
     case 2   %Normal
                sam_pd=makedist('Normal',p1,p2);
end
if(popup_sam_index==1)
    rng('shuffle');
    axis([0,1,-2,2]);
    xaxis=0:.01:1;
    yaxis=cdf(sam_pd,xaxis);
    bound=(yaxis.*(1-yaxis)).^0.5;
    plot(handles.bb,xaxis,bound*-3,'g',xaxis,bound*-2,'r');
    hold(handles.bb,'on');
    hLine1=plot(handles.bb,xaxis,bound*3,'g');
    hLine3=plot(handles.bb,xaxis,bound*2,'r');
    hLine5=plot(handles.bb,observe*ones(101),-2:0.04:2,'magenta');
    legend(handles.bb,[hLine1,hLine3],'3sd','2sd');
    set(handles.empbb,'UserData',0);
    ffx=cdf(sam_pd,observe);
    var=ffx*(1-ffx);
    svar=var^0.5;
    axis(handles.point,[-4*svar,4*svar,0,1]);
    xpd=makedist('normal',0,svar);
    xxaxis=-4.5*svar:.01:4.5*svar;
    yyaxis=cdf(xpd,xxaxis);
    maxdn=zeros(1,1000);
    gob=zeros(1,1000);
    axis([handles.maxbb],[0,2,0,1]);
    maxx=0.3:0.01:2;
    syms k;
    maxy=1+2*symsum((-1)^(k)*exp(-2*k^2*maxx.^2),1,25);
    n=10000;
    up=1000;
    foree=zeros(1,5001);
    for rep=1:up
   if(get(handles.empbb,'UserData')==1)
           break;                                   
    end
    title(handles.bb,sprintf('Number of Realization: %d ', rep),'Fontsize',15);
    title(handles.maxbb,sprintf('Number of Realization: %d ', rep),'Fontsize',15);
    title(handles.point,sprintf('Number of Realization: %d ', rep),'Fontsize',15);
    x=random(sam_pd,n,1);
    y=0:.0002:1;
    ee=foree;
    i=1;
    gob(rep)=(sum(x<=observe)/n-observe)*n^0.5;
    for x_of_sp=0:.0002:1
        ee(i)=sum(x<=x_of_sp);
        i=i+1;
    end
     ee=n^0.5*(ee/n-y);
     scatter(handles.bb,y,ee,1,[0 0 1]);
     maxdn(rep)=max(abs(ee));
     [bbf,bbx]=ecdf(maxdn(1:rep));
     [oof,oox]=ecdf(gob(1:rep));
     plot(handles.maxbb,maxx,maxy,'r',bbx,bbf,'b'); 
     plot(handles.point,oox,oof,'g',xxaxis,yyaxis); 
     latex2=legend(handles.point,'$\hat{Fn(x)}$',sprintf('N(0,%f) ', var));
     set(latex2,'Interpreter','latex');
     clear ee;
     latexl=legend(handles.maxbb,'$\sup_{0<=x<=1}|Bx|$','$\sqrt{n}Dn$');
     set(latexl,'Interpreter','latex');
     drawnow; 
    end    
   hold(handles.bb,'off');
else
    rng('shuffle');
    axis([-4,4,-2,2]);
    xaxis=-4:.01:4;
    yaxis=cdf(sam_pd,xaxis);
    bound=(yaxis.*(1-yaxis)).^0.5;
    plot(handles.bb,xaxis,bound*-3,'g',xaxis,bound*-2,'r');
    hold(handles.bb,'on');
    hLine1=plot(handles.bb,xaxis,bound*3,'g');
    hLine3=plot(handles.bb,xaxis,bound*2,'r');
    hLine5=plot(handles.bb,observe*ones(41),-2:0.1:2,'magenta');
    legend(handles.bb,[hLine1,hLine3],'3sd','2sd');
    set(handles.empbb,'UserData',0);
    ffx=cdf(sam_pd,observe);
    var=ffx*(1-ffx);
    svar=var^0.5;
    axis(handles.point,[-4*svar,4*svar,0,1]);
    xpd=makedist('normal',0,svar);
    xxaxis=-4.5*svar:.01:4.5*svar;
    yyaxis=cdf(xpd,xxaxis);
    maxdn=zeros(1,1000);
    gob=zeros(1,1000);
    axis([handles.maxbb],[0,2,0,1]);
    maxx=0.3:0.01:2;
    syms k;
    maxy=1+2*symsum((-1)^(k)*exp(-2*k^2*maxx.^2),1,25);
    n=10000;
    up=1000;
    foree=zeros(1,2001);
    for rep=1:up
    if(get(handles.empbb,'UserData')==1)
                         break;                         
    end
    title(handles.bb,sprintf('Number of Realization: %d ', rep),'Fontsize',15);
    x=random(sam_pd,n,1);
    y=-4:.004:4;
    ee=foree;
    i=1;
    gob(rep)=(sum(x<=observe)/n-cdf(sam_pd,observe))*n^0.5;
    for x_of_sp=-4:.004:4
        ee(i)=sum(x<=x_of_sp);
        i=i+1;
    end
     ee=n^0.5*(ee/n-cdf(sam_pd,y));
     scatter(handles.bb,y,ee,2,[0 0 1]);
     maxdn(rep)=max(abs(ee));
     [bbf,bbx]=ecdf(maxdn(1:rep));
     [oof,oox]=ecdf(gob(1:rep));
     plot(handles.maxbb,maxx,maxy,'r',bbx,bbf,'b'); 
     plot(handles.point,oox,oof,'b',xxaxis,yyaxis,'r'); 
     latex2=legend(handles.point,'$\hat{Fn(x)}$',sprintf('N(0,%f) ', var));
     set(latex2,'Interpreter','latex');
     clear ee;
     latexl=legend(handles.maxbb,'$\sup_{0<=x<=1}|B(F(x))|$','$\sqrt{n}Dn$');
     set(latexl,'Interpreter','latex');
     drawnow;     
    end    
     hold(handles.bb,'off');
end
 guidata(hObject, handles);  
% --- Executes during object creation, after setting all properties.


% --- Executes during object creation, after setting all properties.
function bb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate bb


% --- Executes on button press in stop3.
function stop3_Callback(hObject, eventdata, handles)
% hObject    handle to stop3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.empbb,'UserData',1);
guidata(hObject, handles);
