%%% signifInds threshold was set at 0.2

modes={'normal','stenosed'};
variables={'CBF','TMAX','ZMAX','DSS0'};
flowTerrs={'ica','vba'};
observs={'meanVal', 'prctle99', 'stdDv', 'kurtVal', 'medVal'};

signifInd=zeros(1,60);
maxlen=size(stenDat,1);
stenlen=maxlen;
normlen=size(normDat,1);
i=1;
order={['healthy n=',num2str(length(normNames))],['stenosed n=',num2str(length(stenNames))]};
for a=variables
    for b=flowTerrs
        for c=observs
            var=a{1};
            terr=b{1};
            observ=c{1};
            mat=zeros(maxlen,2)/0;
            mat(1:normlen,1)=normDat(:,i);
            mat(1:stenlen,2)=stenDat(:,i);
            boxplot(mat);
%             medval=median(normDat(:,i));
            p=ranksum(normDat(:,i),stenDat(:,i));
            signifInd(i)=p;
            title([var,' ',terr,' ',observ,': p value=',num2str(p), ', index #',num2str(i)])
            set(gca,'XtickLabel',order)
            set(gca,'FontSize',14)
%             pause
            M(i)=getframe(gcf);
            i=i+1;
        end
    end
end

for a=variables
    for c=observs
        var=a{1};
        observ=c{1};
        mat=zeros(maxlen,2)/0;
        mat(1:normlen,1)=normDat(:,i);
        mat(1:stenlen,2)=stenDat(:,i);
        boxplot(mat)
%         medval=median(normDat(:,i));
        p=ranksum(normDat(:,i),stenDat(:,i));
        signifInd(i)=p;
        title([var,' territory ratio ',observ,': p value=',num2str(p), ', index #',num2str(i)])
        set(gca,'XtickLabel',order)
        set(gca,'FontSize',14)
%         pause
        M(i)=getframe(gcf);
        i=i+1;
    end
end


v=VideoWriter('/Users/spencerwaddle/Documents/MachineLearning/Box_WhiskerPlots');
open(v);
writeVideo(v,M);
close(v);