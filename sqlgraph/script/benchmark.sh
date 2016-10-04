#!/usr/bin/env bash

# ================================================================
# HEADER
# ================================================================
#  HISTORY
#     2016/08/21 : Alnaimi : Script creation
#     2016/09/05 : Alnaimi : Reformat script
#
#  DESCRIPTION
#     A utility script to govern and benchmark the SQLGraph
#     paper implementaiton on different datasets
# 
#  TO:DO
#     
# ================================================================
# END_OF_HEADER
# ================================================================

# Main script
# ================================================================

# Constant variables to be altered
# ----------------------------------------------------------------

database="benchmark"    # the database name
username="root"         # mysql user
password="pass"         # mysql user password

sql_data="../sqldata/"  # where sqlgraph data will be output
q_result="../results/"  # where results will be output

bak_drive="/backup/"    # the backup drive for old database

# Base directory for where the ldbc data exist
base_dir="/path_to_ldbc_data/"

# MySQL configuration path
mysql_cnf="/etc/mysql/my.cnf"

# Define dataset size dirs located in $base_dir
# this will be appended to the ldbc directory
# e.g. /path_to_ldbc_data/[1G 3G ... 100G]
dataset=("1G" "3G" "10G" "30G" "100G")

# ------------------------- END CONSTANTS -------------------------

# Export password to supress warning
export MYSQL_PWD=$password

# MySQL Performance schema
pf_schema="../resources/setup_perf.sql"
tuned_cnf="../resources/my.cnf"

# For each of the dataset "${dataset[@]}"
# - Execute populatesql.sh
# - Call subroutine execQuery
runBenchmark() {

  # if directory already exists
  if [[ -e $q_result ]]; then
    read -p $'\n'"$q_result dir already exists and old reasult may be overwritten, continue? (Y/N): " -n 1 -r
    if [[ $REPLY =~ ^[Nn]$ ]]; then
      echo $'\n' && safeExit;
    fi
    echo $'\n'
  fi

  # for each of the data sizes
  for size in "${dataset[@]}"; do

    echo $'\n'"# Running the benchmarking script for dataset $size"
    echo "# ###############################################################################################"$'\n'
    
    data_location="$base_dir$size/social_network/"
    echo "Raw data location: $data_location"$'\n'

    echo "# Dropping old database '$database' (if exists) and clearing OS page files."
    echo "# -----------------------------------------------------------------------------------------------"

    # To minimize populateSQL modification, recreate the db here so script doesn't complain
    if ! $(mysql -u $username -vve "CREATE DATABASE $database" &> /dev/null ); then
      mysql -u $username -vve "DROP DATABASE $database;" &> /dev/null;
    fi

    # Drop the page files to clear cache
    echo 3 > /proc/sys/vm/drop_caches; 

    # Output directory for benchmark results
    output=$q_result$size && mkdir -p $output

    echo $'\n'"# Restarting MySQL Service to load custom config for data migration tuning."
    echo "# -----------------------------------------------------------------------------------------------"

    # Temporarily replace config file to speed up migration of SQL data
    mv $mysql_cnf "$mysql_cnf.old" && cp $tuned_cnf $mysql_cnf

    # Restart the MySQL Service to apply config
    /etc/init.d/mysql restart &> /dev/null

    # Run the populateSQL script feeding different data size
    bash ./populatesql.sh -u $username -p $password -d $database -l $data_location -o $sql_data$size

    echo $'\n'"# Restarting MySQL Service to restore old config and backup db into $bak_drive"
    echo "# -----------------------------------------------------------------------------------------------"$'\n'

    # Stop the MySQL Service
    /etc/init.d/mysql stop &> /dev/null 

    # Make sure backup directory does not exist
    mysql_new="$bak_drive""mysql_"$size".bak/"
    if [[ -e $mysql_new ]]; then
      echo "Backup directory $mysql_new already exist, please consolidate... script exiting." && safeExit;
    else 
      mkdir $mysql_new
    fi

    # Backup directory through pv if installed
    if [ $pv_installed -eq 1 ]; then
      mkdir -p $mysql_new && (cd /var/lib/mysql && tar cf - .) | 
        pv -w 70 -s $(du -sb /var/lib/mysql | awk '{print $1}') | (cd $mysql_new && tar xpf -)
    # else copy without progress bar
    else 
      cp -Rp /var/lib/mysql/* $mysql_new 
    fi

    # Restore default configs before running queries
    mv "$mysql_cnf.old" $mysql_cnf

    # Start the MySQL Service to apply
    /etc/init.d/mysql start &> /dev/null 

    # Setup the actors and settings for performance schema
    mysql -u $username < $pf_schema

    # run the query set for specified size
    execQuery $size

  done

  echo $'\n'"Benchmarking finished. Script is exiting."
  echo "# ###############################################################################################"$'\n';
}

# Execute the specified queries
# - Get a running average of 1..5
execQuery() {
  echo $'\n'"# Running the set of queries in ../resources/queries/"
  echo "# -----------------------------------------------------------------------------------------------"$'\n'

  # For each query in the query folder
  for query in `ls -v ../resources/queries/*.sql`; do

    echo -ne "-- Running query $query\033[K\r"; echo
     # Run the query 5 times sequentially
    for i in {1..5}; do
      echo -ne "\033[K---- Running iteration $i\r"
      # Specify the output folder
      result_dir="$q_result/$1/query/iter$i/$(basename $query .sql)/"
      mkdir -p $result_dir

      # Run the query and grab query execution time from the performance schema
      (cat $query; echo "\nSELECT EVENT_ID, TRUNCATE(TIMER_WAIT/1000000000000,6) as Duration \
        FROM performance_schema.events_statements_history ORDER BY EVENT_ID DESC LIMIT 1;") > .tmp.sql

      # Run the fused query and save results
      echo $(mysql -u $username $database -t < .tmp.sql) > $result_dir"result.txt" && rm .tmp.sql 2> /dev/null

    done
  done

  # Clear current line
  echo -ne "\033[K"

  # Grab the size of the database
  mysql -u $username $database -vve "SELECT sum(round(((data_length + index_length)/1024/1024/1024), 2)) \
    as 'Size in GB' FROM information_schema.TABLES WHERE table_schema = '$database';" > "$q_result/$1/size.txt"
}


# Helper functions
# ================================================================

# die function to exit if error
die() { echo "$@" 1>&2; exit 1; }

function trapCleanup() {
  # trapCleanup Function
  # -----------------------------------
  # Any actions to be taken if the script is prematurely exited. 
  # -----------------------------------
  rm .tmp.sql 2> /dev/null       # clean temp file

  mv "$mysql_cnf.old" $mysql_cnf # reinstate old cnf
  /etc/init.d/mysql restart      # restart mysql 

  die "Bennchmarking script trapped."
}

function safeExit() {
  # safeExit
  # -----------------------------------
  # Non destructive exit for when script exits naturally.
  # -----------------------------------
  rm .tmp.sql 2> /dev/null       # clean temp file

  trap - INT TERM EXIT
  exit
}

# Test if PV package installed else run without it
pv_installed=$(dpkg-query -W -f='${Status}' pv 2> /dev/null | grep -c 'ok installed'; )
if [ $pv_installed -eq 0 ]; then
  echo "The package PV is recommended to show progress of MySQL migration."
  read -p "Would you like to install the module? (Y/N): " -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    apt-get install pv -y;
    echo
  else
    echo
  fi
fi

# ========================= End helpers =========================


# ==================== ===================== ====================
# ==                     SCRIPT RUN BELOW                      ==
# ==================== ===================== ====================

# Trap bad exits with your cleanup function
trap trapCleanup EXIT INT TERM

# Set IFS to preferred implementation
IFS=$'\n\t'

# Exit on error. Append '||true' when you run the script if you expect an error.
set -o errexit

#loadDataS
runBenchmark

# Exit safely
safeExit