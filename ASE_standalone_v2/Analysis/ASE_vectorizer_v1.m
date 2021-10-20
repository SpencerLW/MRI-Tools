function [ mat ] = ASE_vectorizer_v1( cellin,acquis,rmnanrows )
%cellin is the input cells. The entries in cellin will be averaged This is
%intended to average left and right sides of the brain, for example, input
%
%[asestruct.rOEF.ms_ASE_RFoff.wm_eroded_L;asestruct.rOEF.ms_ASE_RFoff.wm_eroded_R]
%
%if we want to consider all white matter on the left and right sides of the
%brain

%%% acquis is which acquisitions we want to grab, options are 'first', 'second', 'average' or 'both'.
%%% If both or average are selected, vectorizer will only return rows that have 2 entries.

%%% rmnanrows is 0 or 1. If 1, all rows with any nans at all will be
%%% removed

mat=[];

if strcmp(acquis,'first')
    for j=1:size(cellin,2)
        tempnum=0;
        tempcount=0;
        for i=1:size(cellin,1)
            if cellin{i,j}(1)>0
                tempnum=tempnum+cellin{i,j}(1);
                tempcount=tempcount+1;
            end
        end
        mat(j,1)=tempnum/tempcount;
    end

elseif strcmp(acquis,'second')
    for j=1:size(cellin,2)
        tempnum=0;
        tempcount=0;
        for i=1:size(cellin,1)
            if length(cellin{i,j})>1
                if cellin{i,j}(2)>0
                    tempnum=tempnum+cellin{i,j}(2);
                    tempcount=tempcount+1;
                end
            end
        end
        mat(j,1)=tempnum/tempcount;
    end
elseif strcmp(acquis,'both')
    for j=1:size(cellin,2)
        tempnum1=0;
        tempnum2=0;
        tempcount1=0;
        tempcount2=0;
        for i=1:size(cellin,1)
            if length(cellin{i,j})>1
                if cellin{i,j}(1)>0 
                    tempnum1=tempnum1+cellin{i,j}(1);
                    tempcount1=tempcount1+1;
                end
                if cellin{i,j}(2)>0
                    tempnum2=tempnum2+cellin{i,j}(2);
                    tempcount2=tempcount2+1;
                end
            end
        end
        mat(j,1)=tempnum1/tempcount1;
        mat(j,2)=tempnum2/tempcount2;
    end
elseif strcmp(acquis,'average')
    for j=1:size(cellin,2)
        tempnum=0;
        tempcount=0;
        for i=1:size(cellin,1)
            if length(cellin{i,j})>1
                if cellin{i,j}(1)>0 && cellin{i,j}(2)>0
                    tempnum=tempnum+cellin{i,j}(1)+cellin{i,j}(2);
                    tempcount=tempcount+2;
                end
            end
        end
        mat(j,1)=tempnum/tempcount;
    end
else
    error('invalid input to ASE_vectorizer')
end

if rmnanrows
    for i=1:size(mat,2)
        nanfind=isnan(mat(:,i));
        mat(nanfind,:)=[];
    end
end
end

