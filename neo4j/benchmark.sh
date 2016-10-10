#!/usr/bin/env bash

# ================================================================
# HEADER
# ================================================================
#  HISTORY
#     2016/07/20 : Steer   : Script creation
#     2016/07/25 : Steer   : Script maintenance
#     2016/08/08 : Steer   : Added benchmarking and dataset opt
#                            and a UI for better experience
#     2016/09/26 : Alnaimi : Reformat structure and execution flow
#     2016/09/27 : Alnaimi : Rehauled user interface, standarised
#                            code & fixed naming/style convention
#     2016/10/10 : Alnaimi : Corrected directory path error 
#
#  DESCRIPTION
#     A textual ui to help automate several utilities around Neo4J
#     and the ldbc gen data. 
# 
#  TO:DO
#     
# ================================================================
# END_OF_HEADER
# ================================================================

# Main script
# ================================================================

# environment variables to export
#export LDBC_HOME="/data/completeLDBC"
#export NEO4J_HOME="/data/benchmark/neo4j"

# Define dataset size dirs located in $LDBC_HOME
dataset=("1G" "3G" "10G" "30G" "100G")

runBenchmark() {
  while true; do
    clear && read -p "# MAIN MENU
     Usage:
      1, To ingest data.
      2, To run queries.
      3, To run benchmark.
      x, To terminate program.

    Enter option: "

    case $REPLY in
      "1") echo "Ingesting data"; ingestData ;;
      "2") echo "Running Queryies"; runQueries ;;
      "3") echo "Selecting benchmarks"; selectBenchmark ;;
      "x") safeExit ;;
      *)   echo "Please select a valid option!" ;;
    esac
  done
}

chooseData() {
  while true; do
    clear && echo -n "## Select a dataset [${dataset[@]}]: "

    read -r REPLY
    if [[ " ${dataset[@]} " =~ " $REPLY " ]]; then
      CHOSEN_SET=$REPLY; break ;
    else echo "Please select a valid option!" ;
    fi
  done
}

ingestData() {
  while true; do
    clear && read -p "## Ingesting Data
     Usage:
      1, To use LOAD_CSV.
      2, To use bulk ingester.
      3, To use split ingester.
      m, To return to main menu.
      x, To terminate program.

    Enter option: "

    ccase $REPLY in
      "1") echo "Using LOAD_CSV"; 
           chooseData && DATA_PATH="$LDBC_HOME/$CHOSEN_SET/social_network";

           (cd neo4j-ldbc-ingester && ./populate_neo4j.sh --ldbc $DATA_PATH --db $NEO4J_HOME/data/graph.db) 
           ;;
      "2") echo "Using bulk ingester";
           chooseData && DATA_PATH="$LDBC_HOME/$CHOSEN_SET/social_network_ingest";

           read -p "Do you wish to change headers to fit bulk syntax (only needs to be done once) [y/n]: "
          
           case $REPLY in 
            [yY][eE][sS]|[yY]) (cd neo4j-ldbc-ingester && ./populate_neo4j.sh --ldbc $DATA_PATH --db $NEO4J_HOME/data/graph.db -b -i) ;;
            *) (cd neo4j-ldbc-ingester && ./populate_neo4j.sh --ldbc $DATA_PATH --db $NEO4J_HOME/data/graph.db -b) ;;
           esac
           ;;
      "3") echo "Using split ingester"; 
           chooseData && DATA_PATH="$LDBC_HOME/$CHOSEN_SET/social_network";

           (cd neo4j-ldbc-ingester && ./populate_neo4j.sh --ldbc $DATA_PATH --db $NEO4J_HOME/data/graph.db -s) 
           ;;
      "m") echo "Returning to main menu"; break ;;
      "x") safeExit ;;
      *)   echo "Please select a valid option!" ;;
    esac
    read -n1 -r -p "Done! Press any key to continue..."
  done
}

runQueries() {
  while true; do
    clear && read -p "## Running Queries
     Usage:
      1, To list alla available queries.
      2, To run a specific query.
      3, To run all LDBC queries.
      m, To return to main menu.
      x, To terminate program.

    Enter option: "

    case $REPLY in
      "1") echo "Available Queries: "; ls -v neo4j-ldbc-benchmark/queries/*.cypher ;;
      "2") echo "Available Queries: "; ls -v neo4j-ldbc-benchmark/queries/*.cypher;

           read -p "Please enter the query you wish to run: "
           $NEO4J_HOME/bin/neo4j-shell -file neo4j-ldbc-benchmark/queries/$REPLY
           ;;
      "3") echo "Running LDBC queries"; (cd neo4j-ldbc-benchmark && ./query_benchmark.sh) ;;
      "m") echo "Returning to main menu"; break ;;
      "x") safeExit ;;
      *)   echo "Please select a valid option!" ;;
    esac
    read -n1 -r -p "Done! Press any key to continue..."
  done
}

selectBenchmark() {
  while true; do
    clear && read -p "## Running Benchmarks
     Usage:
      1, To run bulk ingester benchmark.
      2, To run split ingester benchmark.
      3, To run full query benchmark.
      4, To run multihop query benchmark.
      m, To return to main menu.
      x, To terminate program.

    Enter option: "

    case $REPLY in
      "1") echo "Running bulk benchmark"; (cd neo4j-ldbc-benchmark && ./bulk_benchmark.sh) ;;
      "2") echo "Running split benchmark"; (cd neo4j-ldbc-benchmark && ./split_benchmark.sh) ;;
      "3") echo "Running query Benchmark"; (cd neo4j-ldbc-benchmark && ./query_benchmark.sh) ;;    
      "4") echo "Running Hop Benchmark"; (cd neo4j-ldbc-benchmark && ./query_benchmark.sh -h) ;;
      "m") echo "Returning to main menu"; break ;;
      "x") safeExit ;;
      *)   echo "Please select a valid option!" ;;
    esac
    read -n1 -r -p "Done! Press any key to continue..."
  done
}

# Helper functions and prequisites
# ================================================================

# die function to exit if error
die() { echo "$@" 1>&2; exit 1; }

function trapCleanup() {
  # trapCleanup Function
  # -----------------------------------
  # Any actions to be taken if the script is prematurely exited. 
  # -----------------------------------
  die "Migration script trapped."
}

function safeExit() {
  # safeExit
  # -----------------------------------
  # Non destructive exit for when script exits naturally.
  # -----------------------------------
  trap - INT TERM EXIT
  clear
  exit
}

clear && echo $'\n'"# Checking for package dependencies..."$'\n'

# Make sure that both Python3 and MySQL > 5.7 installed
if ! $(type "python" &> /dev/null); then
  die "This script requires the Python runtime to be installed!";
fi

# Test if pyprind package installed, supressing all output
if ! $(python -c "import jinja2" &> /dev/null); then
  echo -e "The Jinja2 module is required for python!" >&2

  read -p "Would you like to install the module? (Y/N): " -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    pip install Jinja2
    echo
  fi
fi

# Check that the Neo4J and LDBC home directories have been set.
if [ -z ${NEO4J_HOME} ]; then 
  echo "NEO4J_HOME enviromental variable value could not been found. Has it been set?" 
  exit 1; 
fi

if [ -z ${LDBC_HOME} ]; then 
  echo "LDBC_HOME enviromental variable value could not been found. Has it been set?" 
  exit 1; 
fi

# =================== End helper & prequisites ===================


# ==================== ===================== ====================
# ==                     SCRIPT RUN BELOW                      ==
# ==================== ===================== ====================

# Trap bad exits with your cleanup function
trap trapCleanup EXIT INT TERM

# Set IFS to preferred implementation
IFS=$'\n\t'

# Exit on error. Append '||true' when you run the script if you expect an error.
set -o errexit

# Run the main function
runBenchmark

# Exit safely
safeExit
