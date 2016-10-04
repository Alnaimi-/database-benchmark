#!/bin/bash
## This script depends on the ingestion scripts having been added to a directory called 'datascripts'
## for each test run size
##
## For the collection of the data size it is assumed the Vertica data is stored in /data.
##
## Steps of script
## - Attempts to create the database (named LDBCx - then the run size - for example LDBCx30GB)
## - Starts the database
## - Run the data loading 
## - Sleeps for 20 mins (to allow Vertica to compress data)
## - Runs the query tests - each test is run non cached and cached.
## - Runs the query designer
## - Sleeps for 20 mins to make sure Vertica has settled
## - Repeats the query tests
## - Finally it stops the database
 
SIZE=(1GB 3GB 10GB 30GB 100GB)

function collectDataSize { 
	TOTAL_SIZE=0
	# Read vertica ips from property file and gather their data sizes
	while read p; do
  		INSTANCE_SIZE=$(ssh $p "du -bs /data/LDBCx$1 | cut -f1")
		TOTAL_SIZE=$(($TOTAL_SIZE + $INSTANCE_SIZE))
	done <vertica_ips.props

        TOTAL_SIZE_MB=$(($TOTAL_SIZE/1024/1024))

        echo -e "Total size $1 $2: $TOTAL_SIZE bytes \t $TOTAL_SIZE_MB megabytes" >> test/totalSize.txt
}

for i in ${SIZE[@]}; do
        echo "datascripts/ingestion${i}.sql"
        if [ ! -f "datascripts/ingestion${i}.sql" ]; then
                echo "Couldn't find ingestion file, please create and put in in datascripts directory file name ingestion${i}.sql"
                exit 1
        fi

        # Remove DB if it exists
        adminTools --tool drop_db -d "LDBCx${i}"
	# Read vertica ips from property file
	NODE_IPS=""
        while read p; do
		if [ ! -z $NODE_IPS ]; then
			NODE_IPS=$NODE_IPS,
		fi
                NODE_IPS=$NODE_IPS$p
        done <vertica_ips.props

        adminTools --tool create_db -d "LDBCx${i}" -s $NODE_IPS
        yes | adminTools --tool start_db -d "LDBCx${i}"
        start=`date +%s`
        vsql -f "datascripts/ingestion${i}.sql"
        end=`date +%s`
        echo "Ingestion time: ${i}, $((end-start))" >> test/ingestionTime.txt

        echo "sleeping for 20 mins"
        sleep 20m

        collectDataSize ${i} "withoutProjections"

        ./query_test.sh ${i} "withoutProjections"
        ./run_designer.sh

        echo "sleep for 20 mins"
        sleep 20m

        ./query_test.sh ${i} "withProjections"

        collectDataSize ${i} "withProjections"

        adminTools --tool stop_db -d "LDBCx${i}" 
done
