#!/bin/bash
readonly script_version="1.0.0"
# utility_send_email.sh
# Created by:  luciano.ventura@gmail.com   2013_01_01


readonly SUCCESS=0                              # generic success
readonly FAILURE=1                              # generic error


if [ -z "$1" -o -z "$2" -o -z "$3" -o -z "$4" -o -z "$5" ]; then
     
    echo $(date +%F" "%T) "ERROR: utility_send_email: check parameters"
    echo
	exit $FAILURE
fi


email_list="$1"
email_title="$2"
email_message="$3"


out_log_file="$4"
err_log_file="$5"


echo "$email_message" | mailx -s "$email_title" $email_list


if [ $? == $SUCCESS ]; then

    echo $(date +%F" "%T) "INFO: emailed to $email_list"                            >> $out_log_file
    exit $SUCCESS
else
    
    echo $(date +%F" "%T) "ERROR: NOT emailed to $email_list, check email service"  >> $err_log_file
    exit $FAILURE 
fi

