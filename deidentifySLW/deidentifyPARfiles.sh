### This program takes 1 input, the full path to a directory. This file will search this directory and all sub directories and de-identify the 
### text contents of all .PAR files found inside.
### Example: ./deidentifyFileNames.sh Directory

### Spencer Waddle 12/08/2018

targDir=$1 ## The input directory will be searched for .PAR files to deidentify

tempFile="TEMP43U6FILE7W28STORAGENB20.txt" ## This file will be used to store parrec names for deidentification

##### send names of PAR files to tempFile
find $targDir -name '*.PAR' -print > $tempFile #### go through your computer and find .PAR files with the PTSTEN key word
find $targDir -name '*.par' -print >> $tempFile #### go through your computer and find .PAR files with the Donahue key word


#### Open each file listed in parFiles.txt and erase all patient information
while read line #### start while loop to read the parFiles.txt file line by line
do
	echo $line #### print the name of the file being deidentified into the terminal
	sed -i '' '6s/:.*/:/' $line #### delete all characters on the 6th line after the : character
	sed -i '' '12s/:.*/:/' $line #### delete all characters on the 12th line after the : character
done < $tempFile #### End loop and specify the name of the file to be read

rm $tempFile
