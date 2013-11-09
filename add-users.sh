#
#!/bin/bash
#
##
## DESCRIPTION: import IPA users from file
## file: col1=group, col2=login, col3=name 
##
## AUTHOR: Jose Faisca
##
## DATE: 2013.11.8
##
## VERSION: 0.1
##

if [ -z "$1" ];then
    echo "Usage: $0 <inputfile>" 
    exit 1
fi

USERID=""			# LOGIN
GROUP=""			# Group
NAME=""				# Name (cn)
FNAME=""			# Firt Name 
LNAME=""			# Last Name
HOMEDIR=""			# Home directory
LOGFILE="addUsers_IPA.log"	# Log file

#remove logfile
rm -fv $LOGFILE

# list all the unique values in the group column  
out=$(awk < $1 '{print $1}' | sort | uniq) 
for g in $out ; do
    echo "add group .." >> $LOGFILE
    echo $g	
    #echo $(ipa group-add $g) >> $LOGFILE
done

while read line           
do           
    USERID=$(echo "$line" | cut -f 1 | sed -e 's/^ *//g' -e 's/ *$//g')  
    GROUP=$(echo "$line" | cut -f 2 | sed -e 's/^ *//g' -e 's/ *$//g') 
    NAME=$(echo "$line" | cut -f 3 | sed -e 's/^ *//g' -e 's/ *$//g')   	
    FNAME=$(echo $NAME | cut -d' ' -f1)
    LNAME=$(echo $NAME | cut -d' ' -f2-)
    LNAME=${LNAME##* }	
    HOMEDIR="/home/$USERID"
    echo "add user .."
    echo $USERID, $GROUP, $FNAME $LNAME  
    #echo $(ipa user-add "$USERID" --first="$FNAME" --last="$LNAME" --cn="$NAME" --homedir="$HOMEDIR" --random) >> $LOGFILE 
    #echo $(ipa group-add-member "$GROUP" --users="$USERID") >> $LOGFILE	
    #echo $(ipa passwd $USERID $USERID) >> $LOGFILE
done <$1   

echo "..."
echo "log file = $LOGFILE"
echo "Done.."

exit 1
