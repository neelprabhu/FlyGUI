function handles = trackandMovie(handles)

prompt = {'Starting frame:','Ending frame:', 'Movie? 1 for yes, 0 for no', 'Output .mat file name:'};
dlg_title = 'Tracking Options'; num_lines = 1; defaultans = {'1','2','0','sequence'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
sFrame = str2double(answer(1)); eFrame = str2double(answer(2)); movie = str2double(answer(3));
fileName = answer{4};
handles.fileName = fileName;
[handles.masterData] = customMembraneTrack(handles.ALL, ...
    handles.options,handles.masterData,sFrame,eFrame,handles);
delete(strcat(fileName,'Backup.mat'))

data = handles.masterData;
save(fileName,'data')
if movie
    Movie = [];
    for ii=1:size(data,2)
        fig = displayGraph(handles.ALL(:,:,ii), data(ii).VALL, data(ii).EALL, 'on'); 
        Movie = [Movie, immovie(print(fig, '-RGBImage'));];
        close(fig);
    end
    fnameall = strcat(fileName,'.avi');
    writerObj = VideoWriter(fnameall);
    writerObj.FrameRate = 2; writerObj.Quality = 100;
    open(writerObj); writeVideo(writerObj, Movie); close(writerObj);
end