#!/usr/bin/env bash

# ================================================================
# HEADER
# ================================================================
#  HISTORY
#     2016/06/29 : Alnaimi : Script creation
#     2016/07/04 : Alnaimi : Reformat script
#     2016/07/05 : Alnaimi : Add long options and other impr.
#
#  TO:DO
#
# ================================================================
# END_OF_HEADER
# ================================================================

# Main script
# ================================================================

version="1.5.2"               						 # Sets version variable

execMysql() { mysql -u $username $database -vve $1 >> $abs_output"/migration.log"; }

function mainScript() {

  echo "# Running the sql graph and data migration script (It's recommended to maximize terminal)"
  echo "# ==============================================================================================="$'\n'

  abs_ldbc=$(readlink -m $ldbc)
	abs_output=$(readlink -m $output)

	if [[ -e $abs_output ]]; then
		read -p "$abs_output already exist, would you like to overwrite it? (Y/N): " -n 1 -r
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			rm -rf $abs_output;
			echo $'\n'
		else safeExit
		fi
	fi

	if ! $(mysql -u $username -vve "CREATE DATABASE $database" &> /dev/null ); then
		read -p "The DB '$database' already exist. Would you like to overwrite it? (Y/N): " -n 1 -r
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			mysql -u $username -vve "DROP DATABASE $database; CREATE DATABASE $database" &> /dev/null;
			echo
		else echo $'\n' && safeExit;
		fi
	fi

	echo $'\n'"The script will now run. No further interaction required."$'\n'

	# Normalise id and convert to property graph
	python3 $sql_normalise $abs_ldbc $abs_output
	python3 $sql_graph $abs_output

	# Load SQLGraph schema
	mysql -u $username $database < $sql_schema                  

	declare -A tables
	tables=( ["VA"]="/json/va/*.csv" ["EA"]="/json/ea/*.csv" ["OPA"]="/adjacency/opa/*.csv"
	["IPA"]="/adjacency/ipa/*.csv" ["OSA"]="/adjacency/osa/*.csv" ["ISA"]="/adjacency/isa/*.csv" )

	echo "# Migrating data into $database. This may take a while"
	echo "# -----------------------------------------------------------------------------------------------"$'\n'

	for table in "${!tables[@]}"; do
		echo "# Populating the $table table..."
		for file in $abs_output${tables["$table"]}; do
			echo "..."

      load_quer="SET autocommit=0; SET unique_checks=0; SET foreign_key_checks=0;  \
        SET sql_log_bin=0; SET PROFILING = 1; LOAD DATA CONCURRENT LOCAL INFILE ""'"$file"'""  \
        INTO TABLE "$table" FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n' IGNORE \
        1 ROWS; SHOW PROFILES; commit;"

			execMysql $load_quer
		done
	done |
	if [ $pv_installed -eq 1 ]; then
		# -time -eta -progress -width -size in bits (echo inside for)
		pv -t -e -p -w 70 -s 420 - > /dev/null;
	else cat
	fi

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
  exit
}

[[ ! $# -eq 0 ]] && echo $'\n'"# Checking for package dependencies"
[[ ! $# -eq 0 ]] && echo "# ==============================================================================================="$'\n'

# Make sure that both Python3 and MySQL > 5.7 installed
if ! $(type "python3" &> /dev/null); then
	die "This script requires the Python3 runtime to be installed!";
fi

if [[ $(mysql -V | awk '{print $5}') < 5.7 ]]; then
	die "This script requires MySQL version equal to or greater than 5.7!";
fi

# Test if pyprind package installed, supressing all output
if ! $(python -c "import pyprind" &> /dev/null); then
	echo -e "The PyPrind module is recommended to show progress bar and resource monitoring." >&2

	read -p "Would you like to install the module? (Y/N): " -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		pip install pyprind
		echo
	fi
fi

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

# =================== End helper & prequisites ===================


# Usage
# ================================================================

usage() {
  echo -n "$(basename $0) [OPTION]... [FILE]...

 Description:
  This script ingest and inserts the Linked Data Benchmark
  Council (LDBC) gen into MySQL 5.7 by first converting the
  gen to Property Graph format as per described in the paper
  http://dl.acm.org/citation.cfm?id=2723732

 Options:
  -u, --username     Username for MySQL DB
  -p, --password     Input MySQL password
  -d, --database     Database name to create
  -l, --ldbc         Input the path to the LDBC gen data
	-o, --output       The output folder for the data
  -i, --interactive  Prompt for values
  -h, --help         Display this help and exit
      --version      Output version information and exit
"
}

# set flags
verbose=false
debug=false
interactive=false
args=()

# A list of all variables to prompt in interactive mode. These variables HAVE
# to be named exactly as the longname option definition in usage().
interactive_opts=(username password database ldbc output)

# constant variables
sql_schema="../resources/ldbc.ddl"
sql_normalise="normalise.py"
sql_graph="propertygraph.py"

# Prompt the user to interactively enter desired variable values.
prompt_options() {
  local desc=
  local val=
  for val in ${interactive_opts[@]}; do

    # Skip values which already are defined
    [[ $(eval echo "\$$val") ]] && continue

    # Parse the usage description for spefic option longname.
    desc=$(usage | awk -v val=$val '
      BEGIN {
        # Separate rows at option definitions and begin line right before
        # longname.
        RS="\n +-([a-zA-Z0-9], )|-";
        ORS=" ";
      }
      NR > 3 {
        # Check if the option longname equals the value requested and passed
        # into awk.
        if ($1 == val) {
          # Print all remaining fields, ie. the description.
          for (i=2; i <= NF; i++) print $i
        }
      }
    ')
    [[ ! "$desc" ]] && continue

    echo -n "$desc: "

    # In case this is a password field, hide the user input
    if [[ $val == "password" ]]; then
      stty -echo; read password; stty echo
      echo
    # Otherwise just read the input
    else
      eval "read $val"
    fi

		echo
  done
}

# Iterate over options breaking -ab into -a -b when needed and --foo=bar into
# --foo bar
optstring=h
unset options
while (($#)); do
  case $1 in
    # If option is of type -ab
    -[!-]?*)
      # Loop over each character starting with the second
      for ((i=1; i < ${#1}; i++)); do
        c=${1:i:1}

        # Add current char to options
        options+=("-$c")

        # If option takes a required argument, and it's not the last char make
        # the rest of the string its argument
        if [[ $optstring = *"$c:"* && ${1:i+1} ]]; then
          options+=("${1:i+1}")
          break
        fi
      done
      ;;

    # If option is of type --foo=bar
    --?*=*) options+=("${1%%=*}" "${1#*=}") ;;
    # add --endopts for --
    --) options+=(--endopts) ;;
    # Otherwise, nothing special
    *) options+=("$1") ;;
  esac
  shift
done
set -- "${options[@]}"
unset options

# Print help if no arguments were passed.
[[ $# -eq 0 ]] && set -- "--help"

# Read the options and set stuff
while [[ $1 = -?* ]]; do
  case $1 in
    -h|--help) usage >&2; safeExit ;;
    --version) echo "$(basename $0) ${version}"; safeExit ;;
    -u|--username) shift; username=${1} ;;
    -p|--password) shift; password=${1} ;;
		-d|--database) shift; database=${1} ;;
		-l|--ldbc) shift; ldbc=${1} ;;
		-o|--output) shift; output=${1} ;;
    -i|--interactive) interactive=1 ;;
    --endopts) shift; break ;;
    *) die "invalid option: '$1'." ;;
  esac
  shift
done

# Store the remaining part as arguments.
args+=("$@")

# ==================== End Options and Usage =====================


# ==================== ===================== ====================
# ==                     SCRIPT RUN BELOW                      ==
# ==================== ===================== ====================

# Trap bad exits
trap trapCleanup EXIT INT TERM

# Set IFS to preferred implementation
IFS=$'\n\t'

# Exit on error. Append '||true' when you run the script if you expect an error.
set -o errexit

# Run in debug mode, if set
if ${debug}; then set -x ; fi

if ((interactive)); then prompt_options;
else
	for val in "${interactive_opts[@]}"; do
		if [ -z $(eval echo "\$$val") ]; then
			echo "You must set the variable $val.";
			safeExit;
		fi
	done
fi

# Export password to supress warning
export MYSQL_PWD=$password

# Invoke the main script
mainScript

# Exit safely
safeExit
