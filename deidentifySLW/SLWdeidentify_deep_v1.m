%%%%%%%%% replace names of all files in a folder.

cd /Users/spencerwaddle/Documents/SLWtools/deidentifySLW

%%%%%%%%%%%%%%% Deidentify options here
%%%% char(39) = '
deidentifyDir='/Volumes/DonahueDataDrive/Data_sort/SCD_Grouped/PedsSCA/TRANSF';
patientName='PATIENT^NAME^^';
folderName='SCD_TRANSF_K014_04';
% newName='SCD_TRANSF_012_01';
newName=folderName;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Check formatting
if ~strcmp(deidentifyDir(end),'/')
    deidentifyDir=[deidentifyDir,'/'];
end

%%%%%%%%% Deidentify par files
system(['/Users/spencerwaddle/Documents/SLWtools/deidentifySLW/deidentifyPARfiles.sh ',deidentifyDir,folderName])

%%%%%%%%%%%% Find filenames in a string
[~,fileString]=system(['find ',deidentifyDir,folderName,' -name *',patientName,'*']);

if isempty(fileString)
    error(['No files with the name ',patientName,' were found.'])
end

%%%%%%% Put filenames into cell vector
breaks=strfind(fileString,newline);
fileCells={};
indstore=0;
for i=1:length(breaks)
    ind=breaks(i);
    fileCells{end+1}=fileString(indstore+1:ind-1);
    indstore=ind;
end

%%%%%% Sort fileCells by filename length
lenvec=zeros(1,length(fileCells));
for i=1:length(fileCells)
    lenvec(i)=length(fileCells{i});
end
[sortlen,sortinds]=sort(lenvec,'descend');
sortedCells=cell(1,length(fileCells));
for i=1:length(sortinds)
    sortedCells{i}=fileCells{sortinds(i)};
    
end
% % % % % % %  Display cell vector
% % % for i=1:length(sortedCells)
% % %     disp(sortedCells{i})    
% % % end

%%%%%% Replace old name with new name

patNameLen=length(patientName);

for i = 1:length(sortedCells)
    oldName=sortedCells{i};
    slashes=strfind(oldName,'/');
    
    oldPath=oldName(1:slashes(end));
    oldBase=oldName(slashes(end)+1:end);
    
    for i=(length(oldBase)-patNameLen+1):-1:1
        if strcmp(oldBase(i:i+patNameLen-1),patientName)
            nameCut=i;
            break
        end
    end
    newBase=[oldBase(1:nameCut-1),newName,oldBase(i+patNameLen:end)];
    newFullName=[oldPath,newBase];
    movefile(oldName,newFullName)
end




















