#!/bin/bash
readonly script_version="1.1.0"
# send_email.sh
# Created by:  luciano.ventura@gmail.com   2013_01_01


readonly SUCCESS=0                              # generic success
readonly FAILURE=1                              # generic error


logger_info(){
    # Function to print messages and variables to STDOUT
    printf "[$(date +%T)] [INFO] - %s \n" "$@"
}


logger_error(){
    # Function to print messages and variables to STDERR
    printf "[$(date +%T)] [ERROR] - %s \n" "$@" 1>&2
}


exit_success(){
    # Function to print exit success and exit
    logger_info "$(basename $0): Exiting with success!"
    exit $SUCCESS
}


exit_failure(){
    # Function to print exit failure and exit
    logger_error "$(basename $0): Exiting with failure!"
    exit $FAILURE
}


show_usage(){
    echo
    echo
    echo
    echo "send email utility"
    echo
    echo "How to use:"
    echo
    echo "$(basename $0)  email_list  email_title  email_message"
    echo
    echo
    echo
}


if [ -z "$1" -o -z "$2" -o -z "$3" ]; then
     
    show_usage
     
    exit_failure
fi


   email_list="$1"
  email_title="$2"
email_message="$3"


if echo "$email_message" | mailx -s "$email_title" $email_list; then
    logger_info "emailed to $email_list"
     
    exit_success

else
    logger_error "NOT emailed to $email_list, check email service"
     
    exit_failure
fi


