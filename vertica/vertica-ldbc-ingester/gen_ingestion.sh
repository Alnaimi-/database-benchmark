#!/bin/bash

#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    ${SCRIPT_NAME} --db database --ldbc ldbcpath 
#%
#% DESCRIPTION
#%    Creates a ingestion.sql for loading LDBC data into Vertica.
#%
#%    --ldbc [path]                 path to LDBC input files
#%    -h, --help                    Print this help
#%    -v, --version                 Print script information
#%                                  bulk, half with Load CSV
#%
#% EXAMPLES
#%    ${SCRIPT_NAME} --db LDBC10G --ldbc ~/home/myuser/ldbc
#%
#================================================================
#- IMPLEMENTATION
#-    author          James Brook
#-    copyright
#-    license         Apache License V2
#-    script_id       1
#-
#================================================================
#  HISTORY
#     2016/09/29 : James Brook : Script creation
#
#================================================================
# END_OF_HEADER
#================================================================

# CONSTANT DEFINES:
CSV_MERGER="VerticaIngestScript.py"
INGESTION_SQL_FILE="ingestion.sql"


#== HEADER Info variables ==#
SCRIPT_HEADSIZE=$(head -200 ${0} |grep -n "^# END_OF_HEADER" | cut -f1 -d:)
SCRIPT_NAME="$(basename ${0})"

#== Command line Arguments ==#
SHORT=h,v
LONG=ldbc:,help,version

#== Usage functions ==#
usage() { printf "Usage: "; head -${SCRIPT_HEADSIZE:-99} ${0} | grep -e "^#+" | sed -e "s/^#+[ ]*//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g" ; }
usagefull() { head -${SCRIPT_HEADSIZE:-99} ${0} | grep -e "^#[%+-]" | sed -e "s/^#[%+-]//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g" ; }
scriptinfo() { head -${SCRIPT_HEADSIZE:-99} ${0} | grep -e "^#-" | sed -e "s/^#-//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g"; }

###### Script main flow:

## Parser options

# Test getOpt to make sure it's getopt(3)
getopt --test > /dev/null
if [[ $? != 4 ]]; then
    echo "`getopt --test` failed in this environment."
    echo "update getopt in to enhanced version in order to run this script."
    exit 2
fi

# temporarily store output to be able to check for errors
# activate advanced mode getopt quoting e.g. via “--options”
# pass arguments only via   -- "$@"   to separate them correctly
PARSED=`getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@"`

if [[ $? != 0 ]]; then
    # e.g. $? == 1
    #  then getopt has complained about wrong arguments to stdout
    usage
    exit 3
fi

# use eval with "$PARSED" to properly handle the quoting
eval set -- "$PARSED"

# Choose options
while true; do
    case "$1" in
        --ldbc)
            LDBC_PATH=$2
            shift 2
            ;;
        -v|--version)
            echo "version 1.0"
	        exit 0
            ;;
        -h|--help)
            usagefull
            exit 0
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Invalid Argument: $1"
	        usage
            exit 4
            ;;
    esac
done

###### Script main flow:

# handle non-option arguments
if [[ -z "$LDBC_PATH" ]] ; then
    echo "Incorrect usage."
    usage
    exit 5
fi

ABS_LDBC_PATH=$(cd $LDBC_PATH; pwd)
python $CSV_MERGER $ABS_LDBC_PATH $TARGET

if [[ $? != 0 ]]; then
    echo "Error while converting the .csv files to a vertica consumable format"
    exit 6
else
    echo -e "\n   [DONE]\n"
fi

echo "  Please excute the ingestion.sql on your Vertica instance, by running this command: \i 'PATH_TO_SCRIPT/ingestion.sql' "
