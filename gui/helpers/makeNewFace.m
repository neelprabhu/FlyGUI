function [faceList] = makeNewFace(handles,frame)

% @author Neel K. Prabhu

masterData = handles.masterData;
M = size(masterData(frame).EALL,1);
E = masterData(frame).EALL;
deleteIndices = [];

srcV = zeros(M,2);
dstV = zeros(M,2);

for ii=1:M
    if isempty(E{ii})
        deleteIndices = [deleteIndices ii];
        continue;
    end
    srcV(ii,:) = fliplr(E{ii}.control(:,1)');
    dstV(ii,:) = fliplr(E{ii}.control(:,end)');
end

for n = 1:length(deleteIndices)
    %srcV(deleteIndices(n),:) = [];
    %dstV(deleteIndices(n),:) = [];
end

curGraph = javaObjectEDT('JunctionGraph', srcV, dstV);

% Make new facelist
javaFaceList = curGraph.getFaceList(srcV, dstV);
faceList = cell(javaFaceList.size(),1);
for ii=1:javaFaceList.size()
    faceList{ii} = javaFaceList.get(ii-1)';
end