fid=fopen('/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Brainsplitter/MMdata.txt');

while ~feof(fid)
    try
        line=fgetl(fid);
        patID=['PROC',line(7:end),'_DSS02MNI.nii.gz'];
        copyfile(['/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Brainsplitter/DSS0_MNI/', ...
            patID],'/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Brainsplitter/DSS0_MM');
    catch e
        disp(e.message)
        disp(['couldnt copy, probably dont have ',patID]);
    end
    
    
end