function [datVec,namesVec] = defineFeatures_v2( files,workingDir,var,mode ...
    ,terr,namesVec,datVec,Observables,numTerrs,datPos,numVars)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes her

for d=files
    file=d{1};                 
    filePath=[workingDir,'/',var,'/',mode,'/',terr,'/',file];
    patID=file(1:end-10);
    patIndex=find(strcmp(namesVec,patID));
    
    if isempty(patIndex)
        namesVec(end+1)={patID};
        datVec=[datVec; zeros(1,numVars*Observables*numTerrs)];
        patIndex=length(namesVec);
    end

    nift=load_nii(filePath);
    nift=nift.img;
    nift=nift(:);
    nift=nift(nift>0);
%     sortNift=sort(nift,'descend');

    %%% define each observable
    meanVal=mean(nift);
    prctl99=prctile(nift,99); % take 99th percentile
    stdDv=std(nift);
    
    varvec=[ meanVal, prctl99, stdDv];

    
%                     disp(varvec)
%                     pause

    try
        datVec(patIndex,datPos:datPos+Observables-1)=varvec; % add data
    catch e
        disp(e.message)
        error('it is likely that the number of observables and the defined value observables dont match')
    end
%     disp(datVec(:,1:15))
%     pause

end

end

