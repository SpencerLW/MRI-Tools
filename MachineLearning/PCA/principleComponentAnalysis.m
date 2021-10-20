%%% This program takes a matrix with each column being a variable and each
%%% row being a different subject and does PCA on that matrix to define the
%%% new principle componenets. To get the X matrix for our data, go to the
%%% main MachineLearning directory and run findObservables.m. This will
%%% give us stenDat and normDat which are the more stenosed and less
%%% stenosed hemisphere data respectively.

% % % X=rand(100,2);
% % % X=[x;y]';

%%%% Show that we can tilt the axes of a line
% X=[1:50; 1:50]';
% X(:,2)=X(:,2)+10*rand(50,1);
% X(:,3)=X(:,3)+10*rand(50,1);


% load('observables_woEDAS')
X=[normDat;stenDat];
X=X(:,[33 37 44 49 56 60]);

Z=(X-mean(X))./std(X); %%% normalized input data
% Z=(X-mean(X));

covZ=Z'*Z;

%%% P=eigvecs D=eigvals
% % e = eig(A)
% % [V,D] = eig(A)
%%% eig, D has eigvals on diag. V has columns are eigvecs so that A*V=V*D

[P,D]=eig(covZ);
D=sum(D,1); %%% eigenvalues 

% [Ds,sortvec]=sort(D,'ascend');
[Ds,sortvec]=sort(D,'descend');

Ps=P(:,sortvec); %%% eigenvectors

% Zs=Z(:,sortvec);

Zs=Z*Ps;

pcaData=Zs;

normLen=size(normDat,1);
stenLen=size(stenDat,1);

% %%%%%%%%%%%%%% Do 3D plot
% scatter3(Zs(1:normLen,1),Zs(1:normLen,2),Zs(1:normLen,3),100,'MarkerFaceColor','k')
% hold on
% scatter3(Zs(normLen+1:end,1),Zs(normLen+1:end,2),Zs(normLen+1:end,3),100,'MarkerFaceColor','g')

normDat_PCA=pcaData(1:normLen,:);
stenDat_PCA=pcaData(normLen+1:end,:);

% % % % % % save('observables_PCA','normDat_PCA','stenDat_PCA')
% %%
% Zs=[normDat_PCA;stenDat_PCA];
% normDat=normDat_PCA;
% stenDat=stenDat_PCA;
% normLen=size(normDat,1);
% stenLen=size(stenDat,1);
%%%%%%%%%%%Do 2D plots
maxval=max(pcaData(:));
minval=min(pcaData(:));
for a=1:size(X,2)
    for b=a:size(X,2)
plot(normDat_PCA(:,a),normDat_PCA(:,b),'k.','MarkerSize',30)
hold on
plot(stenDat_PCA(:,a),stenDat_PCA(:,b),'g.','MarkerSize',30)
axis([minval,maxval,minval,maxval])
title(['Principle component ',num2str(a),' against principle component ',num2str(b)])
set(gca,'FontSize',14)
% set(gca,'YTick',[])
% set(gca,'XTick',[])
pause
clf
    end
end
