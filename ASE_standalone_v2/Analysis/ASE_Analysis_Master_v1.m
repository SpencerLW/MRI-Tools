%%%% Remember, you have to work with ASE_Analysis_v1.m too, to make sure
%%%% the patdirs are correct and such.

cd /Users/spencerwaddle/Documents/SLWtools/ASE_standalone_v2/Analysis
run ASE_Analysis_v1.m

%%%%%% Combine cells like this
% % % [asestruct.rOEF.ms_ASE_RFoff.wm_eroded_L;asestruct.rOEF.ms_ASE_RFoff.wm_eroded_R]

trustvec1=ASE_vectorizer_v1(asestruct.TRUST.HbAA,'first',1);
trustvec2=ASE_vectorizer_v1(asestruct.TRUST.HbAA,'second',1);
asewmrfon1=ASE_vectorizer_v1([asestruct.rOEF.ms_ASE_RFon.wm_eroded_L;asestruct.rOEF.ms_ASE_RFon.wm_eroded_R],'first',1);
asewmrfon2=ASE_vectorizer_v1([asestruct.rOEF.ms_ASE_RFon.wm_eroded_L;asestruct.rOEF.ms_ASE_RFon.wm_eroded_R],'second',1);
asewmrfoff1=ASE_vectorizer_v1([asestruct.rOEF.ms_ASE_RFoff.wm_eroded_L;asestruct.rOEF.ms_ASE_RFoff.wm_eroded_R],'first',1);
asewmrfoff2=ASE_vectorizer_v1([asestruct.rOEF.ms_ASE_RFoff.wm_eroded_L;asestruct.rOEF.ms_ASE_RFoff.wm_eroded_R],'second',1);
vasoasewm1=ASE_vectorizer_v1([asestruct.rOEF.vasoase.wm_eroded_L;asestruct.rOEF.vasoase.wm_eroded_R],'first',1);
vasoasewm2=ASE_vectorizer_v1([asestruct.rOEF.vasoase.wm_eroded_L;asestruct.rOEF.vasoase.wm_eroded_R],'second',1);
ssasewmrfoff1=ASE_vectorizer_v1([asestruct.rOEF.ss_ASE_RFoff.wm_eroded_L;asestruct.rOEF.ss_ASE_RFoff.wm_eroded_R],'first',0);
gmcbf1=ASE_vectorizer_v1([asestruct.CBFmean.GM_L;asestruct.CBFmean.GM_R],'first',0);
gmcbf2=ASE_vectorizer_v1([asestruct.CBFmean.GM_L;asestruct.CBFmean.GM_R],'second',0);

%% REPRODUCIBILITY - Bland Altmann Plots: ASE WM OEF and TRUST
blandaltman_slw_v1(trustvec1,trustvec2);
axis([0.2 0.5 -0.11 0.11])
title(['TRUST',' n = ',num2str(length(trustvec1))])
blandaltman_slw_v1(asewmrfon1,asewmrfon2);
axis([0.2 0.5 -0.11 0.11])
title(['ms-ASE RF on',' n = ',num2str(length(asewmrfon1))])
blandaltman_slw_v1(asewmrfoff1,asewmrfoff2);
axis([0.2 0.5 -0.11 0.11])
title(['ms-ASE RF off',' n = ',num2str(length(asewmrfoff1))])
blandaltman_slw_v1(vasoasewm1,vasoasewm2);
axis([0.2 0.5 -0.11 0.11])
title(['VASOASE',' n = ',num2str(length(vasoasewm1))])

tempcbf1=gmcbf1;tempcbf2=gmcbf2; %%% Gotta remove nans
tempcbf1(isnan(gmcbf2))=[];tempcbf2(isnan(gmcbf2))=[];
blandaltman_slw_v1(tempcbf1,tempcbf2);
% axis([0.2 0.6 -0.11 0.11])
ylim([-3.5 3.5])
title(['CBF',' n = ',num2str(length(tempcbf1))])

%% REPRODUCIBILITY - Regression: ASE WM OEF and TRUST
disp('REPRODUCIBILITY - REGRESSION')
disp(' ')
regresscorr_slw_v1(trustvec1,trustvec2,'TRUST');
axis([0.2 0.5 0.2 0.5])
regresscorr_slw_v1(asewmrfon1,asewmrfon2,'ASE RF on');
axis([0.2 0.5 0.2 0.5])
regresscorr_slw_v1(asewmrfoff1,asewmrfoff2,'ASE RF off');
axis([0.2 0.5 0.2 0.5])
regresscorr_slw_v1(vasoasewm1,vasoasewm2,'VASOASE');
axis([0.2 0.5 0.2 0.5])

tempcbf1=gmcbf1;tempcbf2=gmcbf2; %%% Gotta remove nans
tempcbf1(isnan(gmcbf2))=[];tempcbf2(isnan(gmcbf2))=[];
regresscorr_slw_v1(tempcbf1,tempcbf2,'pCASL CBF');
axis([10 60 10 60])
disp(' ')

%% CORRELATION - Regression: ASE WM OEF correlation with TRUST

% %%%%%%%%%% Use first and second acquisitions
% disp('CORRELATION - REGRESSION')
% disp(' ')
% regresscorr_slw_v1([asewmrfon1;asewmrfon2],[trustvec1;trustvec2],'ASE RF on vs. TRUST OEF');
% xlabel('ASE RF on');ylabel('TRUST OEF');
% regresscorr_slw_v1([asewmrfoff1;asewmrfoff2],[trustvec1;trustvec2],'ASE RF off vs. TRUST OEF');
% xlabel('ASE RF off');ylabel('TRUST OEF');
% regresscorr_slw_v1([vasoasewm1;vasoasewm2],[trustvec1;trustvec2],'VASOASE vs. TRUST OEF');
% xlabel('VASOASE');ylabel('TRUST OEF');
% 
% disp(' ')

%%%%%% Use only first acquisition
disp('CORRELATION - REGRESSION')
disp(' ')
regresscorr_slw_v1(asewmrfon1,trustvec1,'ASE RF on vs. TRUST OEF');
xlabel('ASE RF on');ylabel('TRUST OEF');
regresscorr_slw_v1(asewmrfoff1,trustvec1,'ASE RF off vs. TRUST OEF');
xlabel('ASE RF off');ylabel('TRUST OEF');
regresscorr_slw_v1(vasoasewm1,trustvec1,'VASOASE vs. TRUST OEF');
xlabel('VASOASE');ylabel('TRUST OEF');
tempase1=ssasewmrfoff1;tempase2=trustvec1;
tempase1(isnan(ssasewmrfoff1))=[];tempase2(isnan(ssasewmrfoff1))=[];
regresscorr_slw_v1(tempase1,tempase2,'ss-ASE RF off vs. TRUST OEF');
xlabel('ss-ASE RF off');ylabel('TRUST OEF');
tempase1=ssasewmrfoff1;tempase2=asewmrfoff1;
tempase1(isnan(ssasewmrfoff1))=[];tempase2(isnan(ssasewmrfoff1))=[];
regresscorr_slw_v1(tempase1,tempase2,'ss-ASE RF off vs. ms-ASE RF off');
xlabel('ss-ASE RF off');ylabel('ms-ASE RF off');
disp(' ')

%% Group-Level boxplots


%%%%%%%
%%%%%%% vCBV
%%%%%%%
% %% REPRODUCIBILITY - Regression: ASE WM vCBV
% disp('REPRODUCIBILITY - REGRESSION')
% disp(' ')
% vec1=ASE_vectorizer_v1([asestruct.rvCBV.ms_ASE_RFoff.wm_eroded_L;asestruct.rvCBV.ms_ASE_RFoff.wm_eroded_L],'first',1);
% vec2=ASE_vectorizer_v1([asestruct.rvCBV.ms_ASE_RFoff.wm_eroded_L;asestruct.rvCBV.ms_ASE_RFoff.wm_eroded_L],'second',1);
% regresscorr_slw_v1(vec1,vec2,'ms ASE RFoff');
% axis([0 0.15 0 0.15])
% 
% vec1=ASE_vectorizer_v1([asestruct.rvCBV.ms_ASE_RFon.wm_eroded_L;asestruct.rvCBV.ms_ASE_RFon.wm_eroded_R],'first',1);
% vec2=ASE_vectorizer_v1([asestruct.rvCBV.ms_ASE_RFon.wm_eroded_L;asestruct.rvCBV.ms_ASE_RFon.wm_eroded_R],'second',1);
% regresscorr_slw_v1(vec1,vec2,'ms ASE RFon');
% axis([0 0.15 0 0.15])
% 
% vec1=ASE_vectorizer_v1([asestruct.rvCBV.vasoase.wm_eroded_L;asestruct.rvCBV.vasoase.wm_eroded_R],'first',1);
% vec2=ASE_vectorizer_v1([asestruct.rvCBV.vasoase.wm_eroded_L;asestruct.rvCBV.vasoase.wm_eroded_R],'second',1);
% regresscorr_slw_v1(vec1,vec2,'VASOASE');
% axis([0 0.15 0 0.15])
% 
% 
% 
% %%%%%%%
% %%%%%%% R2'
% %%%%%%%
% %% REPRODUCIBILITY - Regression: ASE WM R2'
% disp('REPRODUCIBILITY - REGRESSION')
% disp(' ')
% vec1=ASE_vectorizer_v1([asestruct.R2prime.ms_ASE_RFoff.wm_eroded_L;asestruct.R2prime.ms_ASE_RFoff.wm_eroded_L],'first',1);
% vec2=ASE_vectorizer_v1([asestruct.R2prime.ms_ASE_RFoff.wm_eroded_L;asestruct.R2prime.ms_ASE_RFoff.wm_eroded_L],'second',1);
% regresscorr_slw_v1(vec1,vec2,'ms ASE RFoff');
% axis([0 10 0 10])
% 
% vec1=ASE_vectorizer_v1([asestruct.R2prime.ms_ASE_RFon.wm_eroded_L;asestruct.R2prime.ms_ASE_RFon.wm_eroded_R],'first',1);
% vec2=ASE_vectorizer_v1([asestruct.R2prime.ms_ASE_RFon.wm_eroded_L;asestruct.R2prime.ms_ASE_RFon.wm_eroded_R],'second',1);
% regresscorr_slw_v1(vec1,vec2,'ms ASE RFon');
% axis([0 10 0 10])
% 
% vec1=ASE_vectorizer_v1([asestruct.R2prime.vasoase.wm_eroded_L;asestruct.R2prime.vasoase.wm_eroded_R],'first',1);
% vec2=ASE_vectorizer_v1([asestruct.R2prime.vasoase.wm_eroded_L;asestruct.R2prime.vasoase.wm_eroded_R],'second',1);
% regresscorr_slw_v1(vec1,vec2,'VASOASE');
% axis([0 10 0 10])

