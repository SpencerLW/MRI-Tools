function [ LHemNift,RHemNift ] = brainSplitter( brain )
% splits an input brain. This has been checked for sidedness, and this
% program does not flip the image orientation


% %%%%%%%%%%%% This code will split the brain but keep the total image size
% %%%%%%%%%%%% the same
% extraPix=mod(length(brain.img(:,1,1)),2);
% imgShift=1; %%%This is hard coded because it is best for slicing MNI_2mm brain
%             %%%If you want to make this more variable you could do this
%             %%%brainSplitter( brain, imgShift ), make the shift a variable
% 
%             LHem=zeros(size(brain.img));
%             RHem=zeros(size(brain.img));
% if imgShift>=0
%     LHem(1+imgShift:floor(end/2),:,:)=brain.img(1+imgShift*2:floor(end/2)+imgShift,:,:);
%     RHem(floor(end/2):-1:1+imgShift,:,:)=brain.img(floor(end/2)+1+imgShift:end-extraPix,:,:);
% elseif imgShift<0
%     LHem(1:floor(end/2)+imgShift,:,:)=brain.img(1:floor(end/2)+imgShift,:,:);
%     RHem(floor(end/2)+imgShift:-1:1,:,:)=brain.img(floor(end/2)+1+imgShift:end-extraPix+imgShift*2,:,:);
% end
% 
% LHemNift=make_nii(LHem,brain.hdr.dime.pixdim(2:4),[brain.hdr.hist.originator(1) brain.hdr.hist.originator(2:3)]);%%need to define voxel sizes and origin
% RHemNift=make_nii(RHem,brain.hdr.dime.pixdim(2:4),[brain.hdr.hist.originator(1) brain.hdr.hist.originator(2:3)]);%%need to define voxel sizes and origin
   


%%%%%%%%% This code will split the brain and make a SMALLER matrix
%%%%%%%%% than that which was put in. For example. a 10x10x10 image
%%%%%%%%% would come out being 5x10x10
extraPix=mod(length(brain.img(:,1,1)),2);
imgShift=1; %%%This is hard coded because it is best for slicing MNI_2mm brain
            %%%If you want to make this more variable you could do this
            %%%brainSplitter( brain, imgShift ), make the shift a variable

if imgShift>=0
    LHem=brain.img(1+imgShift*2:floor(end/2)+imgShift,:,:);
    RHem=brain.img(floor(end/2)+1+imgShift:end-extraPix,:,:);
elseif imgShift<0
    LHem=brain.img(1:floor(end/2)+imgShift,:,:);
    RHem=brain.img(floor(end/2)+1+imgShift:end-extraPix+imgShift*2,:,:);
end

LHemNift=make_nii(LHem,brain.hdr.dime.pixdim(2:4),[brain.hdr.hist.originator(1)/2 brain.hdr.hist.originator(2:3)]);%%need to define voxel sizes and origin
RHemNift=make_nii(flipud(RHem),brain.hdr.dime.pixdim(2:4),[brain.hdr.hist.originator(1)/2 brain.hdr.hist.originator(2:3)]);%%need to define voxel sizes and origin

end

