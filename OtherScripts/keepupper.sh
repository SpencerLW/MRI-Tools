### /Applications/AnyDesk.app/Contents/MacOS/AnyDesk ### This is the program to run
### /Applications/Calculator.app/Contents/MacOS/Calculator ### This is the test program to run

cd /Applications/AnyDesk.app/Contents/MacOS

while True 
do
	x=`pgrep AnyDesk` ## Check if there is an ID associated with AnyDesk
	
	if [ -z "$x" ] ### if AnyDesk has no ID then open it
	then
		./AnyDesk
	fi

	#sleep 1
	sleep 300 ### Wait this many seconds
done


######### This is the test run I made with the calculator app. This works as intended
####cd /Applications/Calculator.app/Contents/MacOS/
####
####while True 
####do
####	x=`pgrep Calculator`
####	
####	if [ -z "$x" ]
####	then
####		./Calculator
####	fi
####
####	echo line
####	sleep 1
####	done
