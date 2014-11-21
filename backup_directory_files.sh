#!/bin/bash
# backup_directory_files.sh
# Created by: luciano.ventura@gmail.com 2014-11-14


# exit codes
readonly SUCCESS=0
readonly FAILURE=1


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
    echo "Backup directory files do NOT include sub-directory"
    echo
    echo "How to use:"
    echo
    echo "$(basename $0) source_directory files_to_exclude backup_directory backup_name"
    echo
    echo ".tar.gz automagicaly added to the backup_name"
    echo
    echo
    echo
}


# Check for missing parameters
if [ -z "$1" -o -z "$2" -o -z "$3" -o -z "$4" ]; then
    show_usage
     
    exit_failure
fi


source_dir="$1"       # directory to backup               
to_exclude="$2"       # files to exclude from backup      "*.ind|*.pag"   "essbase.sec" "*.shit"
backup_dir="$3"       # destination backup                /backup/local
bakup_name="$4"       # destination file name             dirname_files


logger_info "**********************************************"
logger_info "***   Starting $(basename $0)   ***"
logger_info "**********************************************"


# check if final backup file already exist
if [ -e "$backup_dir/$bakup_name.tar.gz" ]; then
    logger_error "delete $backup_dir/$bakup_name.tar.gz before run!"
     
    exit_failure
fi


# list everything, except directories and exclude from exclude list
if ! files_to_bkp=$(find $source_dir -maxdepth 1 ! -type d | egrep -v $to_exclude); then
    logger_error "can NOT find files inside $source_dir"
     
    exit_failure
fi


logger_info "Excluding $to_exclude"


for item in $files_to_bkp; do
    if tar --append --file=$backup_dir/$bakup_name.tar $item 2>>/dev/null; then
        logger_info "added file: $(basename $item)"
     
    else
        logger_error "can NOT append $item into $backup_dir/$bakup_name"
         
        logger_error "check for incomplete file $backup_dir/$bakup_name"
         
        exit_failure
    fi
done


if gzip --force $backup_dir/$bakup_name.tar 2>>/dev/null; then
    logger_info "Success in gzip $backup_dir/$bakup_name.tar"
     
    logger_info "Final file is $backup_dir/$bakup_name.tar.gz"
     
    exit_success

else
    logger_error "can NOT gzip $backup_dir/$bakup_name.tar"
     
    logger_error "check for incomplete file $backup_dir/$bakup_name.tar"
     
    exit_failure
fi


