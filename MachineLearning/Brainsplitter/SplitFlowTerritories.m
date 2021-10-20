%%% after flow territories are generated, they are not split into left and
%%% right hemispheres. This program is used in the case that we decide to
%%% change the flow territories. It is used to split the newly generated
%%% territories.

LICAnift=load_nii('FlowTerritory_LICA_70.nii.gz');
[Llica,Rlica]=brainSplitter(LICAnift);
RICAnift=load_nii('FlowTerritory_RICA_70.nii.gz');
[Lrica,Rrica]=brainSplitter(RICAnift);
VBAnift=load_nii('FlowTerritory_VBA_30.nii.gz');
[Lvba,Rvba]=brainSplitter(VBAnift);

save_nii(Rrica,'RICA_mask.nii.gz')
save_nii(Llica,'LICA_mask.nii.gz')
save_nii(Lvba,'VBA_Lmask.nii.gz')
save_nii(Rvba,'VBA_Rmask.nii.gz')