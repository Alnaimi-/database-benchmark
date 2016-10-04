#!/usr/bin/env bash

dataset=("1G" "3G" "10G" "30G" "100G")

ingesterLoop(){
  for size in "${dataset[@]}"; do
    for i in `seq 1 10`; do
      echo "$size run $i"
      ../neo4j-ldbc-ingester/bulk_ingester.sh "$LDBC_HOME/$size/social_network_ingest" "graph.db" 
        >> results/bulkbenchmark/$sizeresults.txt
      du graph.db -h >> results/bulkbenchmark/$sizesize.txt
      rm -rf graph.db
    done
  done
}

if [ -z ${NEO4J_HOME} ]; then 
  echo "NEO4J_HOME enviromental variable value could not been found. Has it been set?" 
  exit 1; 
fi

if [ -z ${LDBC_HOME} ]; then 
  echo "LDBC_HOME enviromental variable value could not been found. Has it been set?" 
  exit 1; 
fi

############################ Main

echo "  - Change dataset headers? [y/N] "
read response
case $response in [yY][eE][sS]|[yY])
  #change headers of csv files to allow bulk ingester to run
  for size in "${dataset[@]}"; do
    echo "Changing $size headers"
    ../neo4j-ldbc-ingester/change_headers.sh "$LDBC_HOME/$size/social_network_ingest"
  done
esac

#make sure the folder to store the results exists
if [ ! -d "results/bulkbenchmark" ]; then 
  mkdir -p results/bulkbenchmark
fi

#remove the previous graph.db folder if it exists to stop the first query breaking
if [ -d "graph.db" ]; then
  rm -rf graph.db
fi

#run the ingester on the different datasets
ingesterLoop