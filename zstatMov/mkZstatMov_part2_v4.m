%%% Version 2 displays multiple slices

%%% mkZstatMov_part1, the .sh script, does not actually output a .mov file.
%%% Since we would need that file for putting into reports, I've written
%%% this script to turn a selected 4D .nii into a .mov. If you don't like
%%% the output of this script, you can...
%%% 1. Change the slice used to generate the movie in this script.
%%% 2. Open the 4D .nii output by part1, and play it in Horos, Osirix,
%%% FSLview, FSLeyes, or whatever. You can record the movie playing on your
%%% screen.

%%% the filePath variable should be the complete path to the 4D .nii that
%%% you want to convert. If you don't have that, run part1 first.
clear
addpath('code/load_untouch_nii')

%%%%% vvv Things you might need to change vvv
filePath='/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Data_Storing/PTSTEN_150_01/PTSTEN_150_01_zstatMovie.nii.gz';

% % % jitterTime=3; % seconds. 3 dynamics per jitter, 2 seconds per dynamic.
% % % Interpolated linearly down to 3s. WRONG. Each time file represents 1
% % % second, not one dynamic
jitterTime=1.5; % seconds. 3 seconds per jitter, interpolated to 1.5s
fSize=18; %Font Size
fpsSet=10;
% sliceNum=45; %slice displayed in image
colorRange=[2 15]; % color scale for figure
textSpacing=5; % RL, AP label distance from edge. It is possible that RL, AP labels are off.
%%%%% vvv Script you probably don't need to change vvv
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mniString='atlases/MNI152_T1_2mm.nii.gz';
mniNift=load_untouch_nii(mniString);
mniMat=mniNift.img;
mniMat=rot90(mniMat);
clear mniNift

nift=load_untouch_nii(filePath);
dataMat=nift.img;
dataMat=rot90(dataMat);
clear nift

interpVol=@(vol1,vol2) (vol1+vol2)./2;

currTime=0;
count=1; % Just for keeping movie indices straight
for i=1:0.5:size(dataMat,4) %%% loop through time
    clf
    axes('Color','k','XColor','none','YColor','none','Position',[0 0 1 1]) %make background black
    xpos=0; % images on left of screen
    xlen=0.175; %how wide will each image be
    ylen=0.25; % how tall will each image be
    ypos=ylen*3; % images on bottom of screen
    for sliceNum=7:4:size(mniMat,3)-8 %these numbers were selected to give full brain coverage. size(mniMat,3)=91, unless code has been altered
        mniSlice=mniMat(:,:,sliceNum);
        if mod(i,1)==0
            dataSlice=dataMat(:,:,sliceNum,i);
        elseif mod(i,1)==0.5
            dataSlice=interpVol(dataMat(:,:,sliceNum,floor(i)),dataMat(:,:,sliceNum,ceil(i)));
        else
            disp('PROBLEM in nested for loop if/else statements!!!!!!')
            return
        end
        mniAx=axes;
        mniAx.Position=[xpos,ypos,xlen,ylen];
        mniFig=imagesc(mniSlice);
        axis off
        dataAx=axes;
        dataAx.Position=[xpos,ypos,xlen,ylen];
        dataFig=imagesc(dataSlice);
        axis off
        dataMask=zeros(size(dataSlice));
        dataMask(dataSlice>colorRange(1))=1;
        dataFig.AlphaData=dataMask;
        colormap(mniAx,'gray')
        colormap(dataAx,'jet')
        caxis(dataAx,colorRange);
        xpos=xpos+xlen;
        if xpos>=xlen*5 %% 5 images in the x direction
            xpos=0;
            ypos=ypos-ylen;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%% Format image
    fullAx=axes('Position',[0 0 1 1]);
    text('Position',[0.94 0.92],'Units','normalized','String',['Time',newline,'(s)'],'Color',[1 1 1], ...
        'FontSize',fSize,'HorizontalAlignment','center')
    timeStr=num2str(currTime);
    try
        if sum(timeStr(end-1:end)=='.5')~=2 %%% Add .0 on the end of time
            timeStr=[timeStr '.0'];
        end
    catch
        timeStr=[timeStr '.0'];
    end
    text('Position',[0.90 0.84],'Units','normalized','String',timeStr,'Color',[1 1 1], ...
        'FontSize',fSize)
    axis off
    caxis(colorRange)
    colorbar('Position',[xlen*5 0.025 0.025 0.7],'Color',[1 1 1],'Ticks', ...
        colorRange(1):(colorRange(2)-colorRange(1))/4:colorRange(2))%% Set colorbar position and tick labels
    colormap jet
    fullAx.FontSize=18;
    fullAx.FontWeight='bold';
    text('Position',[0.975 0.375],'Units','normalized','String','(Z-Statistic)','Color',[1 1 1], ...
        'FontSize',fSize,'HorizontalAlignment','center','Rotation',90,'FontWeight','bold')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    M(count)=getframe(gcf);
    count=count+1;
    currTime=currTime+jitterTime;
%     pause
end

% find filename and path for naming
slashes=find(filePath=='/');
movPath=filePath(1:slashes(end)-1);
filename=filePath(slashes(end)+1:end);
dots=find(filename=='.');
filename_woExtensions=filename(1:dots(1)-1);

v=VideoWriter([movPath,'/',filename_woExtensions,'.mp4'],'MPEG-4');
v.FrameRate=fpsSet;
open(v);
writeVideo(v,M);
close(v);