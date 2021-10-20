There are a lot of scripts that were used, and it would be confusing to drop the machine learning stuff for a bit and come back.
I don't think I would remember what everything did, so I'm writing this to help aid in working on this incase I have to come back to it or something.

DSS0 data processing tools are in /Users/spencerwaddle/Documents/boldProcessing/Resources/Code/dss0processing.

Tools for processing large groups of data are in /Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Scripts. First put raw data in 
/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Data, then run /Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Scripts/Master2_v2.m from 
command line. Then, sort data and put it in /Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Data_Sorted. Coregister the data using 
/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Data_Sorted/BOLD_coregPipeline_v2.sh. After the data is coregistered, move the appropriate data into 
/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Brainsplitter. Use 
/Users/spencerwaddle/Documents/boldProcessing/Projects/BOLD/Brainsplitter/brainSplitSort.m to split the data. This is the first half of data 
pre-processing.

Move to /Users/spencerwaddle/Documents/MachineLearning, and use /Users/spencerwaddle/Documents/MachineLearning/removeProc.sh to change the DSS0 data naming scheme
into the correct format. use /Users/spencerwaddle/Documents/MachineLearning/maskFlowTerritories.sh to mask the data, it should be moved into 
/Users/spencerwaddle/Documents/MachineLearning/data. Use /Users/spencerwaddle/Documents/MachineLearning/removeEdas.sh to delete data that had EDAS surgery 
performed on it. /Users/spencerwaddle/Documents/MachineLearning/edasinfo.txt contains the info on which hemispheres have had edas surgery. This is the end of 
preprocessing.

To use the machine learning tools, first run /Users/spencerwaddle/Documents/MachineLearning/findObservables.m, which reads data from 
/Users/spencerwaddle/Documents/MachineLearning/data and calculates theobservables using /Users/spencerwaddle/Documents/MachineLearning/defineFeatures.m. 
You have to run findObservables.m before any of the other Machine learning code will work.

Machine Learning Tools

Principle Component Analysis - /Users/spencerwaddle/Documents/MachineLearning/PCA 
I used the PCA data in processing, but found that it didn't improve predictive capacity.

Leave One Out Analysis and Receiver Operator Characteristics - /Users/spencerwaddle/Documents/MachineLearning/leaveOneOut 
This is important, as it is the method we use to determine the effectiveness of a particular SVM. These tools are important enough in the analysis, that 
they have been built into the SVM analysis inherently.

Support Vector Machines. - /Users/spencerwaddle/Documents/MachineLearning/SVM 
The file in which I've developed my svm tools is /Users/spencerwaddle/Documents/MachineLearning/SVM/learnSVM.m. It has a lot of functionality built into it
Just look at what is in there, and build on that if necessary.
