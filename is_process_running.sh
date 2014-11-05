#!/bin/bash
readonly script_version="1.0.0"
# is_process_running.sh
# Created by:  luciano.ventura@gmail.com   2014_04_24


readonly SUCCESS=0                              # process running
readonly FAILURE=1                              # generic error
readonly STOPPED=2                              # process stopped

if [  -z "$1" -o -z "$2" ]
then
    echo
    echo $(date +%F" "%T) "ERROR: Need 02 parameters: process and port! " >&2
    echo
	exit $FAILURE
fi


proc_to_find="$1"
port_to_check="$2" 


if ps -ef | grep " $proc_to_find " | grep -v "is_process_running.sh" | grep -v grep --silent
then
    if netstat -nao | grep "LISTEN" | grep ":$port_to_check " --silent
    then
        exit $SUCCESS
        
    else
        exit $STOPPED
    fi    
    
else
    exit $STOPPED
fi

