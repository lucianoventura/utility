#!/bin/bash
readonly script_version="1.0.0"
# check_file.sh
# Created by:  luciano.ventura@gmail.com   2013_01_01


readonly SUCCESS=0                              # generic success
readonly FAILURE=1                              # generic error

readonly FILE_DONT_EXIST=2
readonly FILE_IS_NOT_FILE=3
readonly FILE_IS_EMPTY=4
readonly FILE_NOT_READ=5


if [ -z "$1" -o -z "$2" -o -z "$3" ]; then
     
    echo $(date +%F" "%T) "ERROR: utility_check_file: check parameters"
    echo
	exit $FAILURE
fi


file_to_check="$1"
out_log_file="$2"
err_log_file="$3"


if [ ! -e "$file_to_check" ]; then
     
    echo $(date +%F" "%T) "ERROR: $file_to_check is NOT there"                           >> $err_log_file 
    exit $FILE_DONT_EXIST
fi


if [ ! -f "$file_to_check" ]; then              # file is not a file :-)
     
    echo $(date +%F" "%T) "ERROR: $file_to_check is NOT a file"                         >> $err_log_file
    exit $FILE_IS_NOT_FILE
fi        


if [ ! -s "$file_to_check" ]; then              # File is not zero byte
     
    echo $(date +%F" "%T) "ERROR: $file_to_check is EMPTY"                               >> $err_log_file
    exit $FILE_IS_EMPTY
fi


if [ ! -r "$file_to_check" ]; then              # File can be read
       
    echo $(date +%F" "%T) "ERROR: $file_to_check is NOT readable"                       >> $err_log_file
    exit $FILE_NOT_READ
fi



echo $(date +%F" "%T) "INFO: $file_to_check is OK"                                      >> $out_log_file    
exit $SUCCESS

