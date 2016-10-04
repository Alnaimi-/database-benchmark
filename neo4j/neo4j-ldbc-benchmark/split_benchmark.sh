#!/usr/bin/env bash

dataset=("1G" "3G" "10G" "30G" "100G")

INGEST_DIR="../neo4j-ldbc-ingester"
INGESTION_CYPHER_FILE="../neo4j-ldbc-ingester/ingestion.cypher"

ingesterLoop(){
  for size in "${dataset[@]}"; do
    for i in `seq 1 10`; do
      echo "$size run $i"
      echo "$size run $i" >> results/splitbenchmark/$sizeresults.txt
        
        echo "Running bulk ingester on first half of the data"
        ./$INGEST_DIR/bulk_ingester.sh $LDBC_HOME/$size/social_network/0 graph.db 
          >> results/splitbenchmark/$sizeresults.txt
        
        echo "Running LOAD_CSV on the second half of the data"
        time $NEO4J_HOME"/bin/neo4j-shell" -config $NEO4J_HOME/conf/neo4j-wrapper.conf -path graph.db -file $INGESTION_CYPHER_FILE 
          >> results/splitbenchmark/$sizeloadresults$i.txt

        du graph.db -h >> results/splitbenchmark/$sizeresults.txt
        rm -rf graph.db
    done
  done
}

############################ Main
if [ -z ${LDBC_HOME} ];  then 
  echo "LDBC_HOME enviromental variable value could not been found. Has it been set?" 
  exit 1; 
fi

#make sure the folder to store the results exists
if [ ! -d "results/splitbenchmark" ];
  then mkdir results/splitbenchmark
fi

#remove the previous test folder if it exists to stop the first query breaking
if [ -d "graph.db" ];
then
  rm -rf graph.db
fi

echo "  - Does the data need to be split? [y/N] "
read response
case $response in [yY][eE][sS]|[yY])
  for size in "${dataset[@]}"; do
    python $INGEST_DIR/datasplit.py $LDBC_HOME/$size/social_network
    ./$INGEST_DIR/change_headers.sh $LDBC_HOME/$size/social_network/0
  done
esac

#run the ingester on the different datasets
ingesterLoop