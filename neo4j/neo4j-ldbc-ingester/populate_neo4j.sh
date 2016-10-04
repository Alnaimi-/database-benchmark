#!/bin/bash

#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    ${SCRIPT_NAME} --db database --ldbc ldbcpath
#%
#% DESCRIPTION
#%    Ingests LDBC datagen data into Neo4j instance, using
#%    using neo4j-import. It assumes that the user has set the
#%    enviromental variable NEO4J home to the path where neo4j is
#%    installed. Tested on Neo4j 2.3.4
#%
#%    --db [file]                   Set neo4j database file name
#%    --ldbc [path]                 path to LDBC input files
#%    -h, --help                    Print this help
#%    -v, --version                 Print script information
#%    -i                            Change the headers of the LDBC
#%                                  for bulk ingestion
#%    -b                            Utilise bulk ingester
#%    -s                            Split the data, ingest half with
#%                                  bulk, half with Load CSV
#%
#% EXAMPLES
#%    ${SCRIPT_NAME} --db LDBC10G --ldbc ~/home/myuser/ldbc
#%
#================================================================
#- IMPLEMENTATION
#-    author          Alhamza Alnaimi
#-    copyright
#-    license         Apache License V2
#-    script_id       1
#-
#================================================================
#  HISTORY
#     2016/05/11 : Alhamza Alnaimi : Script creation
#
#================================================================
# END_OF_HEADER
#================================================================

# CONSTANT DEFINES:
CSV_MERGER="Neo4jMerger.py"
IMPORT_COMMAND=$NEO4J_HOME"/bin/neo4j-shell"
DATA_SPLITTER="datasplit.py"
INGESTION_CYPHER_FILE="ingestion.cypher"

#File Flags
USE_BULK=false
SET_HEADER=false
SPLIT_DATA=false

#== HEADER Info variables ==#
SCRIPT_HEADSIZE=$(head -200 ${0} |grep -n "^# END_OF_HEADER" | cut -f1 -d:)
SCRIPT_NAME="$(basename ${0})"

#== Command line Arguments ==#
SHORT=h,v,i,b,s
LONG=db:,ldbc:,help,version

#== Usage functions ==#
usage() { printf "Usage: "; head -${SCRIPT_HEADSIZE:-99} ${0} | grep -e "^#+" | sed -e "s/^#+[ ]*//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g" ; }
usagefull() { head -${SCRIPT_HEADSIZE:-99} ${0} | grep -e "^#[%+-]" | sed -e "s/^#[%+-]//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g" ; }
scriptinfo() { head -${SCRIPT_HEADSIZE:-99} ${0} | grep -e "^#-" | sed -e "s/^#-//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g"; }

###### Script main flow:

if [ -z ${NEO4J_HOME} ]; then echo "NEO4J_HOME enviromental variable value could not been found. Has it been set?" && exit 1; fi

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
        --db)
            DATABASE_NAME=$2
            shift 2
            ;;
        --ldbc)
            LDBC_PATH=$2
            shift 2
            ;;

        -i)
            SET_HEADER=true
            shift
            ;;

        -s)
            SPLIT_DATA=true
            shift
            ;;

        -b)
            USE_BULK=true
            shift
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

# handle non-option arguments
if [[ -z "$DATABASE_NAME" || -z "$LDBC_PATH" ]] ; then
    echo "Incorrect usage."
    usage
    exit 5
fi

#handle bad combinations
if $SET_HEADER ; then
    if ! $USE_BULK; then
        echo "Please also set the -b flag if you wish to change the folder headers"
        echo "Exiting"
        exit 2
    fi
    if $SPLIT_DATA; then
        echo "You cannot split the data and set headers at the same time, please use either -b, -b -i or -s"
        echo "Exiting"
        exit 2
    fi
fi

if $SPLIT_DATA ; then
    if $USE_BULK; then
        echo "You cannot split the data and run the bulk ingester at the same time, please use either -b, -b -i or -s"
        exit
    fi
fi

ABS_LDBC_PATH=$(cd $LDBC_PATH; pwd)
#launch csv conversion passing user request
echo -e "Launching .csv conversion scripts\n"
if $USE_BULK; then
    python $CSV_MERGER $ABS_LDBC_PATH "Bulk"
else 
    if $SPLIT_DATA; then
        python $CSV_MERGER $ABS_LDBC_PATH "Split"
    else
        python $CSV_MERGER $ABS_LDBC_PATH "Load_CSV"
    fi
fi

if [[ $? != 0 ]]; then
    echo "Error while converting the .csv files to a neo4j consumable format"
    exit 6
else
    echo -e "\n   [DONE]\n"
fi

echo "Populating NEO4J LDBC database"

if [[ -d $DATABASE_NAME ]]; then
    echo "  - Database already exists. Would you like to overwrite it?  [y/N] "
    read response

    case $response in
    [yY][eE][sS]|[yY])
        rm -r -f $DATABASE_NAME
        echo "  - Clean up done"
        ;;
    *)
        echo "  - Database untouched!"
        exit 0
        ;;
    esac
fi

#change headers of files if user requests
if $SET_HEADER ; then
    for f in $LDBC_PATH
    do
        if ! [ -w $LDBC_PATH ] ; then
            echo "$f is not writeable by the user."
            exit 2
        fi
    done
    ./change_headers.sh $LDBC_PATH
fi

#run the chosen ingester

splitIngester() {
	echo "Running bulk ingester on first half of the data"
        ./bulk_ingester.sh $LDBC_PATH/0 $DATABASE_NAME
        echo "Running LOAD_CSV on the second half of the data"
        time $IMPORT_COMMAND -config $NEO4J_HOME/conf/neo4j-wrapper.conf -path $DATABASE_NAME -file $INGESTION_CYPHER_FILE
        exit 0
}

#if split data chosen, check if previous split data exists and if user wants to overwrite it
if $SPLIT_DATA; then
    if [[ -d $LDBC_PATH/0 ]]; then
        echo "  There is previous split data, do you wish to overwrite?  [y/N] "
        read response

        case $response in [yY][eE][sS]|[yY])
            echo "Splitting data"
            python $DATA_SPLITTER $ABS_LDBC_PATH
            ./change_headers.sh $LDBC_PATH/0
            splitIngester
            ;;
        *)
            echo "  - Data untouched!"
	        splitIngester
            ;;
        esac
    else
    	echo "Splitting data"
    	python $DATA_SPLITTER $ABS_LDBC_PATH
        ./change_headers.sh $LDBC_PATH/0
	    splitIngester
    fi
fi

#if user has selected the bulk ingester, run that, otherwise run LOAD_CSV
if $USE_BULK; then
    ./bulk_ingester.sh $LDBC_PATH $DATABASE_NAME
else
    $IMPORT_COMMAND -config $NEO4J_HOME/conf/neo4j-wrapper.conf -path $DATABASE_NAME -file $INGESTION_CYPHER_FILE
fi
