#!/bin/bash

## times to repeat queries
QUERY_REPEAT=5
PROJECTIONS=$2

TEST_RUN_NAME=$1
QUERIES=(query2 query6 query8 query9 query11 query9multihop1 query9multihop3 query9multihop4 query9multihop5) 

## Function to lookup the stats of a given query, it takes four parameters: query label, cache state, start and end date
function stats {
echo "Stats for $1 $2 between Start-> $3 End-> $4"

##echo "select identifier, query_duration_us as 'Duration (us)', processed_row_count,error_code from query_profiles where identifier = '${1}' and query_start > '$3' and query_start < '$4' order by query_start"
vsql -c "select identifier, query_duration_us as 'Duration (us)', processed_row_count,error_code from query_profiles where identifier = '${1}' and query_start > '$3' and query_start < '$4' order by query_start"

echo "**** Summary *****"

vsql -c "select identifier, count(query_duration_us) as '#samples', avg(query_duration_us) as 'Avg (us)', min(query_duration_us) as 'Min (us)', max(query_duration_us) as 'Max (us)', stddev(query_duration_us), processed_row_count,error_code from query_profiles where identifier = '${1}' and query_start > '$3' and query_start < '$4' group by identifier, processed_row_count, error_code;"
}

## 
function statsToFile {
STATS_DIR="test/${PROJECTIONS}/${TEST_RUN_NAME}/${2}" 
echo $STATS_DIR
mkdir -p $STATS_DIR
echo "Record stats to file $1 $2 between Start-> $3 End-> $4"
vsql -c "select identifier, query_duration_us as 'Duration (us)', case when error_code is null then 'OK' ELSE 'FAILED' END from query_profiles where identifier = '${1}' and query_start > '$3' and query_start < '$4' order by query_start" >> "${STATS_DIR}/result_${1}"

}

# Clears the OS cache on all cluster hosts, removes any Vertica cache.
# Requires root privilege on the user to run it
function clearCache {

vsql -f clear_cache.sql
# Cleans cache in parallel
while read p; do
  echo "dropping cache on: $p"
  ssh $p "sudo sh -c \"sync; echo 3 > /proc/sys/vm/drop_caches\"" &
done <vertica_ips.props

wait
echo "Cache cleaned on cluster"
}

## Function to execute a query WITHOUT caching, parameters are test section start time, query name and number of times to repeat
function runQueryNoCache {
echo "Start time is $1"
echo "Running queries (no cache) - $2"
for i in `seq 1 $3`;
do
clearCache
vsql -f "${2}.sql"
done
}

## Function to execute a query WITH caching, parameters are test section start time, query name and number of times to repeat
function runQueryWithCache {
echo "Start time is $1"
echo "Running queries (cache) - $2"
for i in `seq 1 $3`;
do
vsql -f "${2}.sql"
done
}

# The queries are designed to be run be the dbadmin user. That is Vertica's admin
if [ "$(whoami)" != "dbadmin" ]; then
	echo "[ERROR] This script should be run by the admin of vertica db (dbadmin)."
	exit 1
fi

# check that we have a vertica host file (for clearing the caches
if [ ! -f vertica_ips.props ]; then
    echo "Missing 'vertica_ips.props' file, please provide one."
exit 1
fi

## START OF PROCESS
## start time for the NOT cached queries
NO_CACHE_QUERY_START=`vsql --quiet --no-vsqlrc -X -Atc "SELECT CURRENT_TIMESTAMP"`;

## Loop around the queries calling them for the non cached version
for i in ${QUERIES[@]}; do
	runQueryNoCache "$NO_CACHE_QUERY_START" $i $QUERY_REPEAT
done

NO_CACHE_QUERY_END=`vsql --quiet --no-vsqlrc -X -Atc "SELECT CURRENT_TIMESTAMP"`;

## Run each query once to warm up cache

CACHE_WARM_QUERY_START=`vsql --quiet --no-vsqlrc -X -Atc "SELECT CURRENT_TIMESTAMP"`;

echo -e "\n[STARTING CACHE WARMUP - no time information being recorded]\n"
for i in ${QUERIES[@]}; do
	runQueryWithCache "$CACHE_WARM_QUERY_START" $i 1
done
echo -e "[CACHE WARMUP COMPLETED]\n"

CACHE_QUERY_START=`vsql --quiet --no-vsqlrc -X -Atc "SELECT CURRENT_TIMESTAMP"`;

## Run cached queries:
for i in ${QUERIES[@]}; do
	runQueryWithCache "$CACHE_QUERY_START" $i $QUERY_REPEAT
done

CACHE_QUERY_END=`vsql --quiet --no-vsqlrc -X -Atc "SELECT CURRENT_TIMESTAMP"`;

for i in ${QUERIES[@]}; do
	stats $i 'NoCache' "$NO_CACHE_QUERY_START" "$NO_CACHE_QUERY_END"
	stats $i 'WithCache' "$CACHE_QUERY_START" "$CACHE_QUERY_END"
done

for i in ${QUERIES[@]}; do
        statsToFile $i 'NoCache' "$NO_CACHE_QUERY_START" "$NO_CACHE_QUERY_END" 
        statsToFile $i 'WithCache' "$CACHE_QUERY_START" "$CACHE_QUERY_END"
done

