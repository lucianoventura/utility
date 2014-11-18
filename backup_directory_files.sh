#!/bin/bash
# backup_directory_files.sh
# Created by: luciano.ventura@gmail.com 2014-11-14


# exit codes
readonly SUCCESS=0
readonly FAILURE=1


show_usage(){
    echo
    echo "Backup directory files only, do NOT include directories inside."
    echo
    echo "How to use:"
    echo
    echo "$(basename $0) source_directory files_to_exclude backup_directory backup_name out_log_file err_log_file"
    echo
    echo " .tar.gz automagicaly added to the backup_name"
    echo
    echo "Exiting..."
    echo
}


# Check for missing parameters
if [ -z "$1" -o -z "$2" -o -z "$3" -o -z "$4" -o -z "$5" -o -z "$6" ]
then
    show_usage
    
    exit $FAILURE
fi


  source_dir="$1"       # directory to backup               
  to_exclude="$2"       # files to exclude from backup      "*.ind|*.pag"   "essbase.sec" "*.shit"

  backup_dir="$3"       # destination backup                /backup/local
  bakup_name="$4"       # destination file name             dirname_files

out_log_file="$5"       # output log file                   /dev/null for no log
err_log_file="$6"       # error  log file                   /dev/null for no log


if [ -e "$backup_dir/$bakup_name.tar.gz" ]
then
    echo ""                                                                                 | tee    $err_log_file
    echo "[$(date +%T)] [ERROR] delete $backup_dir/$bakup_name.tar.gz before run!"          | tee -a $err_log_file
    echo ""                                                                                 | tee -a $err_log_file
    echo "Exiting..."
    echo
    exit $FAILURE
fi


# list (only files) and exclude from exclude list
files_to_bkp=$(find $source_dir -type f | egrep -v $to_exclude)


for item in $files_to_bkp
do
    if ! tar --append --file=$backup_dir/$bakup_name.tar $item >$out_log_file 2>$err_log_file   # if fail to execute tar
    then
        echo ""                                                                                 | tee -a $err_log_file
        echo "[$(date +%T)] [ERROR] can NOT append $item into $backup_dir/$bakup_name"          | tee -a $err_log_file
        echo ""                                                                                 | tee -a $err_log_file
        echo "[$(date +%T)] [ERROR] check for incomplete file $backup_dir/$bakup_name"          | tee -a $err_log_file
        echo ""                                                                                 | tee -a $err_log_file
        exit $FAILURE
    fi
done


echo ""                                                                                         | tee -a $out_log_file
echo "[$(date +%T)] [INFO] Success in append files to $backup_dir/$bakup_name.tar"              | tee -a $out_log_file
echo ""                                                                                         | tee -a $out_log_file


# debug: tar --list --file=$backup_dir/$bakup_name.tar | sort
# debug: echo


if ! gzip --force $backup_dir/$bakup_name.tar                                         >>$out_log_file 2>>$err_log_file
then
    echo ""                                                                                     | tee -a $err_log_file
    echo "[$(date +%T)] [ERROR] can NOT gzip $backup_dir/$bakup_name.tar"                       | tee -a $err_log_file
    echo ""                                                                                     | tee -a $err_log_file
    echo "[$(date +%T)] [ERROR] check for incomplete file $backup_dir/$bakup_name.tar"          | tee -a $err_log_file
    echo ""                                                                                     | tee -a $err_log_file
    exit $FAILURE
else
    echo "[$(date +%T)] [INFO] Success in gzip $backup_dir/$bakup_name.tar"                     | tee -a $out_log_file
    echo ""                                                                                     | tee -a $out_log_file
    echo "[$(date +%T)] [INFO] Final file is $backup_dir/$bakup_name.tar.gz"                    | tee -a $out_log_file
    echo ""                                                                                     | tee -a $out_log_file
    exit $SUCCESS
fi


