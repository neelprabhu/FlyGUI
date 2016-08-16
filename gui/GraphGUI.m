function varargout = GraphGUI(varargin)
% GRAPHGUI MATLAB code for GraphGUI.fig
%      GRAPHGUI, by itself, creates a new GRAPHGUI or raises the existing
%      singleton*.
%
%      H = GRAPHGUI returns the handle to a new GRAPHGUI or the handle to
%      the existing singleton*.
%
%      GRAPHGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRAPHGUI.M with the given input arguments.
%
%      GRAPHGUI('Property','Value',...) creates a new GRAPHGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GraphGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GraphGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GraphGUI_OpeningFcn, ...
    'gui_OutputFcn',  @GraphGUI_OutputFcn, ...
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

function GraphGUI_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for GraphGUI
handles.output = hObject;

% Lots of parameters, some unnecessary...
setup;
l = 17;                 % width of edge window
w = 25;                 % width of vertex window
alpha = 0.5;            % scaling edge cost contributions
interval = 1;           % merge vertices if distance is less or equal
spacing = 15;           % spacing of control points on splines
parallel = false;       % parallelization with parfor
verboseE = 0;           % verbose flag for edge optimization
verboseG = 0;           % verbose flag for vertex optimization
siftflow = true;        % SIFT flow flag
fname = ['tmp_grid2_', datestr(clock,'mmddyy_HH:MM:SS')];
handles.options = struct('l',l,'w',w,'alpha',alpha,'interval',interval, ...
    'spacing',spacing,'parallel',parallel,'verboseE',verboseE, ...
    'verboseG',verboseG,'siftflow',siftflow,'fname',fname);

% Parameters into handles
handles.vertexIdx = -1; % No vertex selected default
handles.clickDown = 0;
handles.isAdd = 0; % Not adding element default
handles.addVertex = 0; % Not adding element default
handles.addEdge = 0;
handles.getStats = 0;
handles.isChanged = 0;
handles.prevVIdx = 1; handles.onV = false;
handles.prevEIdx = 1; handles.onE = false;
set(handles.frame,'String','1');
guidata(hObject,handles)

global ALL;
if ~isempty(ALL)
    handles = guidata(hObject);
    newhandles = initialize(handles);
    guidata(hObject,newhandles)
    showGraph_Callback(handles.showGraph,eventdata,handles);
end

%% Code for tracking mouse movements and clicks

set(gca,'Visible','off') % Turns off axes
set(gcf, 'WindowButtonDownFcn', @selectPoint);
set(gcf, 'WindowButtonMotionFcn', @trackPoint);
set(gcf, 'WindowButtonUpFcn', @stopTracking);
set(gcf, 'KeyPressFcn', @buttonPress);

function selectPoint(hObject,eventdata) % When mouse is clicked
    
handles = guidata(hObject);
masterData = handles.masterData;
prelimPoint = get(gca,'CurrentPoint');
prelimPoint = prelimPoint(1,1:2);
handles.clickDown = 1;

% Check if query is in boundaries, else return
if inpolygon(prelimPoint(1),prelimPoint(2), ...
        [handles.zStX handles.zStoX],[handles.zStY handles.zStoY])
    handles.cp = prelimPoint;
else
    return;
end

% Find nearest vertex and edge
[handles.vertexIdx,handles.vD] = nearestNeighbor(handles.vDT,handles.cp);
[handles.edgeIdx,handles.eD] = nearestNeighbor(handles.eDT,handles.cp);
guidata(hObject,handles)

% Adding vertex
if handles.addVertex
    newhandles = vertAdd(handles);
    guidata(hObject,newhandles)
    return;
end

if handles.addEdge == 1  
    handles.E1 = handles.vertexIdx;
    handles.addEdge = 2;
    guidata(hObject,handles)
    return;
end

if handles.addEdge == 2
    newhandles = edgeAdd(handles);
    guidata(hObject,newhandles)
    return;
end

newhandles = changeColor(handles);
guidata(hObject,newhandles)

function trackPoint(hObject,eventdata)
handles = guidata(hObject);
newhandles = pointTrack(handles);
guidata(hObject,newhandles)

function stopTracking(hObject,eventdata)
handles = guidata(hObject);
newhandles = trackStop(handles);
guidata(hObject,newhandles)
    
function buttonPress(hObject,eventdata)
handles = guidata(hObject);
switch eventdata.Key
    case 'backspace' % if backspace is pressed
        newhandles = deleteVE(handles);
        guidata(hObject,newhandles)
    case 'n'
        handles.addVertex = 1;
        guidata(hObject,handles)
    otherwise % do nothing
end

function handles = deleteVE(oldhandles)
handles = deleteElement(oldhandles);

% --- Outputs from this function are returned to the command line.
function varargout = GraphGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function showGraph_Callback(hObject, eventdata, handles)
% hObject    handle to showGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
newhandles = graphShow(handles);
guidata(hObject,newhandles)

function frame_Callback(hObject, eventdata, handles)
% hObject    handle to frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frame as text
%        str2double(get(hObject,'String')) returns contents of frame as a double
handles = guidata(hObject);
handles.f = str2double(get(hObject,'String'));
if size(handles.masterData,2) >= handles.f
    handles.vDT = setVVoronoi(handles);
    handles.eDT = setEVoronoi(handles);
    handles.oldData = handles.masterData(handles.f);
    guidata(hObject,handles)
    showGraph_Callback(handles.showGraph,eventdata,handles)
else
    guidata(hObject,handles)
    showRaw_Callback(handles.showRaw,eventdata,handles)
end

function frame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function add_element_Callback(hObject, eventdata, handles)
% hObject    handle to add_element (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
newhandles = vertButton(handles);
guidata(hObject,newhandles)

function showRaw_Callback(hObject, eventdata, handles)
% hObject    handle to showRaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
imagesc(handles.ALL(:,:,handles.f));

function open_track_Callback(hObject, eventdata, handles)
% hObject    handle to open_track (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
newhandles = trackandMovie(handles);
guidata(hObject,newhandles)

% --- Executes on button press in add_edge.
function add_edge_Callback(hObject, eventdata, handles)
% hObject    handle to add_edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
newhandles = edgeButton(handles);
guidata(hObject,newhandles)

% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
newhandles = imLoad(handles);
guidata(hObject,newhandles)
showGraph_Callback(handles.showGraph, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Menu Bar %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Do nothing

function edit_Callback(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Do nothing

function view_Callback(hObject, eventdata, handles)
% hObject    handle to view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Do nothing

function sGraph_Callback(hObject, eventdata, handles)
% hObject    handle to sGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
showGraph_Callback(handles.showGraph, eventdata, handles)

function sRaw_Callback(hObject, eventdata, handles)
% hObject    handle to sRaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
showRaw_Callback(handles.showRaw, eventdata, handles)

function addV_Callback(hObject, eventdata, handles)
% hObject    handle to addV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
handles.addVertex = 1;
guidata(hObject,handles)

function addE_Callback(hObject, eventdata, handles)
% hObject    handle to addE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
handles.addEdge = 1;
guidata(hObject,handles)

function delete_Callback(hObject, eventdata, handles)
% hObject    handle to delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
newhandles = deleteVE(handles);
guidata(hObject,newhandles)

function dataLoad_Callback(hObject, eventdata, handles)
% hObject    handle to dataLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load_Callback(handles.load, eventdata, handles)

function track_Callback(hObject, eventdata, handles)
% hObject    handle to track (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
open_track_Callback(handles.open_track, eventdata, handles)

function undo_Callback(hObject, eventdata, handles)
% hObject    handle to Undo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
newhandles = undo(handles);
guidata(hObject,newhandles)
showGraph_Callback(handles.showGraph,eventdata,handles);

function getParameters_Callback(hObject, eventdata, handles)
% hObject    handle to getParameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
newhandles = parameterGet(handles);
guidata(hObject,newhandles)