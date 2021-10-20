function [ outstruct ] = fillASEvals_v1( instruct,asevec,scantype,vartype,newpat)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    outstruct=instruct;
    vecnames={'GM_L','GM_R','frontal_L','frontal_R','occipital_L','occipital_R','parietal_L', ...
        'parietal_R','temporal_L','temporal_R','wm_eroded_L','wm_eroded_R'};
    if contains(scantype,'CBF')
        for i=1:length(asevec)
            if ~newpat
                outstruct.(scantype).(vecnames{i}){end}=[outstruct.(scantype).(vecnames{i}){end}, asevec(i)];
            else
                outstruct.(scantype).(vecnames{i}){end+1}= asevec(i);
            end
        end
    else
        for i=1:length(asevec)
            if ~newpat
                outstruct.(vartype).(scantype).(vecnames{i}){end}=[outstruct.(vartype).(scantype).(vecnames{i}){end}, asevec(i)];
            else
                outstruct.(vartype).(scantype).(vecnames{i}){end+1}= asevec(i);
            end
        end
    end
end
