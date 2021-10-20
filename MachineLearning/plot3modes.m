%%% Run findObservables.m first to generate controlDat, stenDat, and
%%% normDat
% cd('/Users/spencerwaddle/Documents/MachineLearning')
% findObservables()

% ind1=3;
% ind2=11;

for ind1=1:30
    for ind2=ind1+1:30
        clf
% %%% For plotting all three groups
% plot(controlDat(:,ind1),controlDat(:,ind2),'k*',normDat(:,ind1),normDat(:,ind2),'b*', ...
%     stenDat(:,ind1),stenDat(:,ind2),'r*','LineWidth',2,'MarkerSize',16)
% %%% For plotting controls and less stenosed
plot(controlDat(:,ind1),controlDat(:,ind2),'k*',normDat(:,ind1),normDat(:,ind2),'b*', ...
    'LineWidth',2,'MarkerSize',16)
%%% For plotting controls and more stenosed
% plot(controlDat(:,ind1),controlDat(:,ind2),'k*', ...
%     stenDat(:,ind1),stenDat(:,ind2),'r*','LineWidth',2,'MarkerSize',16)
title(['ind1=',num2str(ind1),' ind2=',num2str(ind2)]);
pause
    end
end