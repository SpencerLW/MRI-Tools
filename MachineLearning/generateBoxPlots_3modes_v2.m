% modes={'controls','normal','stenosed'};
% % numModes=length(modes);
% variables={'CBF','TMAX','ZMAX','DSS0'};
% % numVars=length(variables);
% flowTerrs={'ica','vba'};
% % numTerrs=length(flowTerrs);
% observs={'meanVal', 'prctle99', 'stdDv'};
% % numObs=length(observs);
% 
% % signifInd=zeros(1,60);
% maxlen=size(stenDat,1);
stenlen=maxlen;
normlen=size(normDat,1);
controllen=size(controlDat,1);
pnamesVec=cell(size(stenDat,2),1);
pvalsVec=zeros(size(stenDat,2),3);
i=1;
order={['control n=',num2str(length(controlNames))],['normal n=',num2str(length(normNames))],['stenosed n=',num2str(length(stenNames))]};
for a=variables
    for b=flowTerrs
        for c=observs
            var=a{1};
            terr=b{1};
            observ=c{1};
            mat=zeros(maxlen,3)/0;
            mat(1:normlen,2)=normDat(:,i);
            mat(1:stenlen,3)=stenDat(:,i);
            mat(1:controllen,1)=controlDat(:,i);
%             boxplot(mat);
            boxplot(mat,'whisker',Inf);
            
            p12=ranksum(normDat(:,i),stenDat(:,i));% norm v sten
            p23=ranksum(stenDat(:,i),controlDat(:,i));% sten v control
            p13=ranksum(normDat(:,i),controlDat(:,i));% norm v control
%             signifInd(i)=p;
            title([var,' ',terr,' ',observ,', index #',num2str(i),', p-values:',newline,'cont-norm=',num2str(p13),': norm-sten=',num2str(p12),': cont-sten=', ...
            num2str(p23)])
        
            pnamesVec(i)={[var,' ',terr,' ',observ]};
            pvalsVec(i,:)=[p13 p12 p23];
            set(gca,'XtickLabel',order)
            set(gca,'FontSize',14)
            M(i)=getframe(gcf);
            i=i+1;
        end
    end
end

%%%% add CBF ica CoV
var='CBF';
terr='ica';
observ='CoV';
mat=zeros(maxlen,3)/0;
mat(1:normlen,2)=normDat(:,25);
mat(1:stenlen,3)=stenDat(:,25);
mat(1:controllen,1)=controlDat(:,25);
boxplot(mat,'whisker',Inf);
p12=ranksum(normDat(:,25),stenDat(:,25));% norm v sten
p23=ranksum(stenDat(:,25),controlDat(:,25));% sten v control
p13=ranksum(normDat(:,25),controlDat(:,25));% norm v control
title([var,' ',terr,' ',observ,', index #',num2str(i),', p-values:',newline,'cont-norm=',num2str(p13),': norm-sten=',num2str(p12),': cont-sten=', ...
num2str(p23)])
pnamesVec(i)={[var,' ',terr,' ',observ]};
pvalsVec(i,:)=[p13 p12 p23];
set(gca,'XtickLabel',order)
set(gca,'FontSize',14)
M(i)=getframe(gcf);
i=i+1;

%%%%% add CBF vba CoV
var='CBF';
terr='vba';
observ='CoV';
mat=zeros(maxlen,3)/0;
mat(1:normlen,2)=normDat(:,26);
mat(1:stenlen,3)=stenDat(:,26);
mat(1:controllen,1)=controlDat(:,26);
boxplot(mat,'whisker',Inf);
p12=ranksum(normDat(:,26),stenDat(:,26));% norm v sten
p23=ranksum(stenDat(:,26),controlDat(:,26));% sten v control
p13=ranksum(normDat(:,26),controlDat(:,26));% norm v control
title([var,' ',terr,' ',observ,', index #',num2str(i),', p-values:',newline,'cont-norm=',num2str(p13),': norm-sten=',num2str(p12),': cont-sten=', ...
num2str(p23)])
pnamesVec(i)={[var,' ',terr,' ',observ]};
pvalsVec(i,:)=[p13 p12 p23];
set(gca,'XtickLabel',order)
set(gca,'FontSize',14)
M(i)=getframe(gcf);
i=i+1;

%%%%% add age
mat=zeros(maxlen,3)/0;
mat(1:normlen,2)=normDat(:,i);
mat(1:stenlen,3)=stenDat(:,i);
mat(1:controllen,1)=controlDat(:,i);
boxplot(mat,'whisker',Inf);
p12=ranksum(normDat(:,i),stenDat(:,i));% norm v sten
p23=ranksum(stenDat(:,i),controlDat(:,i));% sten v control
p13=ranksum(normDat(:,i),controlDat(:,i));% norm v control
title(['Age , index #',num2str(i),', p-values:',newline,'cont-norm=',num2str(p13),': norm-sten=',num2str(p12),': cont-sten=', ...
num2str(p23)])
pnamesVec(i)={'Age'};
pvalsVec(i,:)=[p13 p12 p23];
set(gca,'XtickLabel',order)
set(gca,'FontSize',14)
M(i)=getframe(gcf);
i=i+1;

%%%%% add gender
mat=zeros(maxlen,3)/0;
mat(1:normlen,2)=normDat(:,i);
mat(1:stenlen,3)=stenDat(:,i);
mat(1:controllen,1)=controlDat(:,i);
boxplot(mat,'whisker',Inf);
p12=ranksum(normDat(:,i),stenDat(:,i));% norm v sten
p23=ranksum(stenDat(:,i),controlDat(:,i));% sten v control
p13=ranksum(normDat(:,i),controlDat(:,i));% norm v control
title(['Sex , index #',num2str(i),', p-values:',newline,'cont-norm=',num2str(p13),': norm-sten=',num2str(p12),': cont-sten=', ...
num2str(p23)])
pnamesVec(i)={'Sex'};
pvalsVec(i,:)=[p13 p12 p23];
set(gca,'XtickLabel',order)
set(gca,'FontSize',14)
M(i)=getframe(gcf);
i=i+1;

%%%%% add diabetes
mat=zeros(maxlen,3)/0;
mat(1:normlen,2)=normDat(:,i);
mat(1:stenlen,3)=stenDat(:,i);
mat(1:controllen,1)=controlDat(:,i);
boxplot(mat,'whisker',Inf);
p12=ranksum(normDat(:,i),stenDat(:,i));% norm v sten
p23=ranksum(stenDat(:,i),controlDat(:,i));% sten v control
p13=ranksum(normDat(:,i),controlDat(:,i));% norm v control
title(['Diabetes , index #',num2str(i),', p-values:',newline,'cont-norm=',num2str(p13),': norm-sten=',num2str(p12),': cont-sten=', ...
num2str(p23)])
pnamesVec(i)={'Diabetes'};
pvalsVec(i,:)=[p13 p12 p23];
set(gca,'XtickLabel',order)
set(gca,'FontSize',14)
M(i)=getframe(gcf);
i=i+1;

%%%%% add smoking
mat=zeros(maxlen,3)/0;
mat(1:normlen,2)=normDat(:,i);
mat(1:stenlen,3)=stenDat(:,i);
mat(1:controllen,1)=controlDat(:,i);
boxplot(mat,'whisker',Inf);
p12=ranksum(normDat(:,i),stenDat(:,i));% norm v sten
p23=ranksum(stenDat(:,i),controlDat(:,i));% sten v control
p13=ranksum(normDat(:,i),controlDat(:,i));% norm v control
title(['Smoking , index #',num2str(i),', p-values:',newline,'cont-norm=',num2str(p13),': norm-sten=',num2str(p12),': cont-sten=', ...
num2str(p23)])
pnamesVec(i)={'Smoking'};
pvalsVec(i,:)=[p13 p12 p23];
set(gca,'XtickLabel',order)
set(gca,'FontSize',14)
M(i)=getframe(gcf);
i=i+1;

%%%%% add race
mat=zeros(maxlen,3)/0;
mat(1:normlen,2)=normDat(:,i);
mat(1:stenlen,3)=stenDat(:,i);
mat(1:controllen,1)=controlDat(:,i);
boxplot(mat,'whisker',Inf);
p12=ranksum(normDat(:,i),stenDat(:,i));% norm v sten
p23=ranksum(stenDat(:,i),controlDat(:,i));% sten v control
p13=ranksum(normDat(:,i),controlDat(:,i));% norm v control
title(['Race , index #',num2str(i),', p-values:',newline,'cont-norm=',num2str(p13),': norm-sten=',num2str(p12),': cont-sten=', ...
num2str(p23)])
pnamesVec(i)={'Race'};
pvalsVec(i,:)=[p13 p12 p23];
set(gca,'XtickLabel',order)
set(gca,'FontSize',14)
M(i)=getframe(gcf);
i=i+1;


v=VideoWriter('/Users/spencerwaddle/Documents/MachineLearning/Box_WhiskerPlots_3modes');
open(v);
writeVideo(v,M);
close(v);
%% remove specified data and make pvals bar plot for less v more and cont v less
%%% in pvalsVec, index (i,1) is cont v norm, (i,2) is norm v sten, and (i,3)
%%% is cont v sten. we are primarily interested in (i,[1,2]) norm=less

%%%%%%%%%%%%%% Generate names for pval plot
modes={'controls','normal','stenosed'};
% numModes=length(modes);
variables={'CBF','TMAX','ZMAX','DSS0'};
% numVars=length(variables);
flowTerrs={'ica','vba'};
% numTerrs=length(flowTerrs);
observs={'meanVal', 'prctle99', 'stdDv','kurtVal','medVal'};

pnamesVec=cell(size(stenDat,2),1);
pvalsVec=zeros(size(stenDat,2),3);
i=1;
for a=variables
    for b=flowTerrs
        for c=observs
            var=a{1};
            terr=b{1};
            observ=c{1};
            
            p12=ranksum(normDat(:,i),stenDat(:,i));% norm v sten
            p23=ranksum(stenDat(:,i),controlDat(:,i));% sten v control
            p13=ranksum(normDat(:,i),controlDat(:,i));% control v norm
                        
            pnamesVec(i)={[var,' ',terr,' ',observ]};
            pvalsVec(i,:)=[p13 p12 p23];
                       
            i=i+1;
        end
    end
end
for a=variables
    for b={'ratio'}
        for c=observs
            var=a{1};
            terr=b{1};
            observ=c{1};
            
            p12=ranksum(normDat(:,i),stenDat(:,i));% norm v sten
            p23=ranksum(stenDat(:,i),controlDat(:,i));% sten v control
            p13=ranksum(normDat(:,i),controlDat(:,i));% control v norm
                        
            pnamesVec(i)={[var,' ',terr,' ',observ]};
            pvalsVec(i,:)=[p13 p12 p23];
                       
            i=i+1;
        end
    end
end
return
%%%%%%%%%%%%%%%%%%%%%%%%
paxis=0.05;
signifVal=0.05/12;
rmInds=find(contains(pnamesVec,'medVal') | contains(pnamesVec,'kurtVal'));

pnamesVec(rmInds)=[];
pvalsVec(rmInds,:)=[];

axisNamesVec=pnamesVec(contains(pnamesVec,'ica'));
for i=1:length(axisNamesVec)
    line2=axisNamesVec{i};
    
    for j=1:length(line2)
        tempLine=line2(j:j+3);
        if strcmp(tempLine,'ica ')
            line2=[line2(1:j-1) line2(j+4:end)];
            break
        end
    end
    axisNamesVec(i)={line2};
end

axisVals=[0 13 0 paxis];


% %%%%% Exclude VBA plots and cont v more plots
% subplot(2,2,1)
% bar(pvalsVec(contains(pnamesVec,'ica'),1))
% hold on
% plot(axisVals(1:2),[signifVal, signifVal],'--r','LineWidth',3)
% axis(axisVals)
% title('ica cont v less')
% ylabel('p-values')
% xticklabels(axisNamesVec)
% xtickangle(90)
% 
% subplot(2,2,2)
% bar(pvalsVec(contains(pnamesVec,'ica'),2))
% hold on
% plot(axisVals(1:2),[signifVal, signifVal],'--r','LineWidth',3)
% axis(axisVals)
% title('ica less v more')
% ylabel('p-values')
% xticklabels(axisNamesVec)
% xtickangle(90)
% 
% subplot(2,2,3)
% bar(pvalsVec(contains(pnamesVec,'ratio'),1))
% hold on
% plot(axisVals(1:2),[signifVal, signifVal],'--r','LineWidth',3)
% axis(axisVals)
% title('ica/vba cont v less')
% ylabel('p-values')
% xticklabels(axisNamesVec)
% xtickangle(90)
% 
% subplot(2,2,4)
% bar(pvalsVec(contains(pnamesVec,'ratio'),2))
% hold on
% plot(axisVals(1:2),[signifVal, signifVal],'--r','LineWidth',3)
% axis(axisVals)
% title('ica/vba less v more')
% ylabel('p-values')
% xticklabels(axisNamesVec)
% xtickangle(90)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%
% %%%%% Exclude only cont vs more
% subplot(3,2,1)
% bar(pvalsVec(contains(pnamesVec,'ica'),1))
% axis(axisVals)
% title('ica cont v less')
% ylabel('p-values')
% xticklabels(axisNamesVec)
% xtickangle(90)
% 
% subplot(3,2,2)
% bar(pvalsVec(contains(pnamesVec,'ica'),2))
% axis(axisVals)
% title('ica less v more')
% ylabel('p-values')
% xticklabels(axisNamesVec)
% xtickangle(90)
% 
% subplot(3,2,3)
% bar(pvalsVec(contains(pnamesVec,'vba'),1))
% axis(axisVals)
% title('vba cont v less')
% ylabel('p-values')
% xticklabels(axisNamesVec)
% xtickangle(90)
% 
% subplot(3,2,4)
% bar(pvalsVec(contains(pnamesVec,'vba'),2))
% axis(axisVals)
% title('vba less v more')
% ylabel('p-values')
% xticklabels(axisNamesVec)
% xtickangle(90)
% 
% subplot(3,2,5)
% bar(pvalsVec(contains(pnamesVec,'ratio'),1))
% axis(axisVals)
% title('ica/vba cont v less')
% ylabel('p-values')
% xticklabels(axisNamesVec)
% xtickangle(90)
% 
% subplot(3,2,6)
% bar(pvalsVec(contains(pnamesVec,'ratio'),2))
% axis(axisVals)
% title('ica/vba less v more')
% ylabel('p-values')
% xticklabels(axisNamesVec)
% xtickangle(90)
% %%%%%%%%%%%%%%%%%%%%

%% remove specified data and make pvals plot for all plots
%%% in pvalsVec, index (i,1) is cont v norm, (i,2) is norm v sten, and (i,3)
%%% is cont v sten. we are primarily interested in (i,[1,2]) norm=less

paxis=0.05;
signifVal=0.05/12;

rmInds=find(contains(pnamesVec,'medVal') | contains(pnamesVec,'kurtVal'));

pnamesVec(rmInds)=[];
pvalsVec(rmInds,:)=[];

axisNamesVec=pnamesVec(contains(pnamesVec,'ica'));
for i=1:length(axisNamesVec)
    line2=axisNamesVec{i};
    
    for j=1:length(line2)
        tempLine=line2(j:j+3);
        if strcmp(tempLine,'ica ')
            line2=[line2(1:j-1) line2(j+4:end)];
            break
        end
    end
    axisNamesVec(i)={line2};
end

% % % % % %% This was used to check that the axis names are the same for all 3
% % % % % %% cases. They were
% % vec1=axisNamesVec;
% % 
% % 
% % axisNamesVec=pnamesVec(contains(pnamesVec,'vba'));
% % for i=1:length(axisNamesVec)
% %     line2=axisNamesVec{i};
% %     
% %     for j=1:length(line2)
% %         tempLine=line2(j:j+3);
% %         if strcmp(tempLine,'vba ')
% %             line2=[line2(1:j-1) line2(j+4:end)];
% %             break
% %         end
% %     end
% %     axisNamesVec(i)={line2};
% % end
% % vec2=axisNamesVec;
% % 
% % axisNamesVec=pnamesVec(contains(pnamesVec,'ratio'));
% % for i=1:length(axisNamesVec)
% %     line2=axisNamesVec{i};
% %     
% %     for j=1:length(line2)
% %         tempLine=line2(j:j+5);
% %         if strcmp(tempLine,'ratio ')
% %             line2=[line2(1:j-1) line2(j+6:end)];
% %             break
% %         end
% %     end
% %     axisNamesVec(i)={line2};
% % end
% % vec3=axisNamesVec;

axisVals=[0 13 0 paxis];
% axisVals=[0 21 0 paxis];

% % % set(gca, 'YScale', 'log') %%% Log scale didn't work out, its hard to
% standardize the bottom of the scale and have it look right, since the p
% values are different by like 8 orders of magnitude. Use this code after
% each bar command if you want to give it another shot.

subplot(3,3,1)
bar(pvalsVec(contains(pnamesVec,'ica'),1))
hold on
plot(axisVals(1:2),[signifVal, signifVal],'--r','LineWidth',3)
axis(axisVals)
title('ica cont v less')
ylabel('p-values')
xticklabels(axisNamesVec)
xtickangle(90)

subplot(3,3,2)
bar(pvalsVec(contains(pnamesVec,'ica'),2))
hold on
plot(axisVals(1:2),[signifVal, signifVal],'--r','LineWidth',3)
axis(axisVals)
title('ica less v more')
ylabel('p-values')
xticklabels(axisNamesVec)
xtickangle(90)

subplot(3,3,3)
bar(pvalsVec(contains(pnamesVec,'ica'),3))
hold on
plot(axisVals(1:2),[signifVal, signifVal],'--r','LineWidth',3)
axis(axisVals)
title('ica cont v more')
ylabel('p-values')
xticklabels(axisNamesVec)
xtickangle(90)

subplot(3,3,4)
bar(pvalsVec(contains(pnamesVec,'vba'),1))
hold on
plot(axisVals(1:2),[signifVal, signifVal],'--r','LineWidth',3)
axis(axisVals)
title('vba cont v less')
ylabel('p-values')
xticklabels(axisNamesVec)
xtickangle(90)

subplot(3,3,5)
bar(pvalsVec(contains(pnamesVec,'vba'),2))
hold on
plot(axisVals(1:2),[signifVal, signifVal],'--r','LineWidth',3)
axis(axisVals)
title('vba less v more')
ylabel('p-values')
xticklabels(axisNamesVec)
xtickangle(90)

subplot(3,3,6)
bar(pvalsVec(contains(pnamesVec,'vba'),3))
hold on
plot(axisVals(1:2),[signifVal, signifVal],'--r','LineWidth',3)
axis(axisVals)
title('vba cont v more')
ylabel('p-values')
xticklabels(axisNamesVec)
xtickangle(90)

subplot(3,3,7)
bar(pvalsVec(contains(pnamesVec,'ratio'),1))
hold on
plot(axisVals(1:2),[signifVal, signifVal],'--r','LineWidth',3)
axis(axisVals)
title('ica/vba cont v less')
ylabel('p-values')
xticklabels(axisNamesVec)
xtickangle(90)

subplot(3,3,8)
bar(pvalsVec(contains(pnamesVec,'ratio'),2))
hold on
plot(axisVals(1:2),[signifVal, signifVal],'--r','LineWidth',3)
axis(axisVals)
title('ica/vba less v more')
ylabel('p-values')
xticklabels(axisNamesVec)
xtickangle(90)

subplot(3,3,9)
bar(pvalsVec(contains(pnamesVec,'ratio'),3))
hold on
plot(axisVals(1:2),[signifVal, signifVal],'--r','LineWidth',3)
axis(axisVals)
title('ica/vba cont v more')
ylabel('p-values')
xticklabels(axisNamesVec)
xtickangle(90)

% %%%%%%% Find significant values
% test={};
% for i=1:length(pnamesVec)
%     test{i,1}=pnamesVec{i};
%     test{i,2}=pvalsVec(i,1);
%     test{i,3}=pvalsVec(i,2);
%     test{i,4}=pvalsVec(i,3);
% end
% 
% test2=cell(size(test));
% for i=1:numel(test)
%     if isa(test{i},'char')
%         test2{i}=test{i};
%     elseif isa(test{i},'double')
%         if test{i}<signifVal
%             test2{i}=test{i};
%         elseif test{i}>=signifVal
%             test2{i}='nonSignif';
%         else
%             disp('error 1')
%         end
%     else 
%         disp('error 2')
%     end
%     
% end
% delVec=[];
% for i=1:size(test2,1)
%     if contains(test2{i},'vba')
%         delVec=[delVec i];
%     end
% end
% test2(delVec,:)=[];
% test2=[{' ','ContvLess','LessvMore','ContvMore'};test2];

%% For generating single boxplots
maxlen=size(stenDat,1);
stenlen=maxlen;
normlen=size(normDat,1);
controllen=size(controlDat,1);
order={['control n=',num2str(length(controlNames))],['normal n=',num2str(length(normNames))],['stenosed n=',num2str(length(stenNames))]};

%%%%%%%%%%% Change these
var='CBF';
i=3;
terr='ica';
observ='std';
%%%%%%%%%%%%%%%%%%%%%%

%%%% Plot Data Points
plot(ones(length(controllen),1),controlDat(:,i),'gp','MarkerSize',8)
hold on
plot(2*ones(length(normlen),1),normDat(:,i),'bo','MarkerSize',8)
hold on
plot(3*ones(length(stenlen),1),stenDat(:,i),'rd','MarkerSize',8)
%%%%%%

mat=zeros(maxlen,3)/0;
mat(1:normlen,2)=normDat(:,i);
mat(1:stenlen,3)=stenDat(:,i);
mat(1:controllen,1)=controlDat(:,i);
h=boxplot(mat,'whisker',Inf);
set(h,{'linew'},{2})

p12=ranksum(normDat(:,i),stenDat(:,i));% norm v sten
p23=ranksum(stenDat(:,i),controlDat(:,i));% sten v control
p13=ranksum(normDat(:,i),controlDat(:,i));% norm v control
title([var,' ',terr,' ',observ,', index #',num2str(i),', p-values:',newline,'cont-norm=',num2str(p13),': norm-sten=',num2str(p12),': cont-sten=', ...
num2str(p23)])
set(gca,'XtickLabel',order)
set(gca,'FontSize',14)
axis square