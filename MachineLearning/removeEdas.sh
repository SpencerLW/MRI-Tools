input="/Users/spencerwaddle/Documents/MachineLearning/edasinfo.txt"


###while IFS='' read -r line || [[ -n "$line" ]]; do
###    echo "$line"
###done < "$input"

while read line
do
	set -- $line
	names=`find /Users/spencerwaddle/Documents/MachineLearning/data -name "*$1_$2ica*"`
	rm $names
	names=`find /Users/spencerwaddle/Documents/MachineLearning/data -name "*$1_$2vba*"`
	rm $names
	names=`find /Users/spencerwaddle/Documents/MachineLearning/data -name "*$1_$3ica*"`
	rm $names
	names=`find /Users/spencerwaddle/Documents/MachineLearning/data -name "*$1_$3vba*"`
	rm $names

	
done < $input
