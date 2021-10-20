function [ outliersvec ] = isoutlier_slw_v2( vec,method,range_exclude )
% outliersvec is a binary vector where 0 is not outlier, 1 is outlier
% method can be 'IQR', 'STD', or 'CI'
% IQR: Exclude points outside of IQR * range_exclude (recommend 1.5) from vec
% STD: Exclude points outside of range_exclude standard deviations (recommend 2.5)
% CI exclude points outside of 
    vec_nonan=vec;
    vec_nonan(isnan(vec_nonan))=[];
    method=lower(method);
    if strcmp(method,'iqr')
        r=iqr(vec_nonan);
        outliersvec1=vec<quantile(vec_nonan,0.25)-r*range_exclude;
        outliersvec2=vec>quantile(vec_nonan,0.75)+r*range_exclude;
        outliersvec=outliersvec1|outliersvec2;
    elseif strcmp(method,'std')
        stdval=std(vec_nonan);
        meanval=mean(vec_nonan);
        outliersvec1=vec<(meanval-range_exclude*stdval);
        outliersvec2=vec>(meanval+range_exclude*stdval);
        outliersvec=outliersvec1|outliersvec2;
    elseif strcmp(method,'ci')
        error('CI method has not been programmed yet. recommend using 2.5 in std option')
    else
        error('Invalid method input')
    end

end

