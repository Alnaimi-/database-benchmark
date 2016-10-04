#!/usr/bin/env bash

# Define dataset size dirs located in $base_dir
dataset=("1G" "3G" "10G" "30G" "100G")

loadDB() {
  for size in "${dataset[@]}"; do
    DATA_PATH="$LDBC_HOME/$size/social_network_ingest"

    if [ -d $NEO4J_HOME/data/graph.db ]; then
      rm -r -f $NEO4J_HOME/data/graph.db
    fi

    # Change dir due to python file scope
    echo $'\n'"Ingesting and migrating the $1 db into Neo4J..."
    (cd ../neo4j-ldbc-ingester && ./bulk_ingester.sh $DATA_PATH $NEO4J_HOME/data/graph.db &> /dev/null)

    # Restart neo4j service
    $NEO4J_HOME/bin/neo4j restart

    runQuery $size
  done
}

runQuery() {
  # Warm up the silly cache
  $NEO4J_HOME/bin/neo4j-shell -file "queries/warm.cypher" &> /dev/null

  echo $'\n'"Running the set of queries in the folder 'queries'..."
  for query in `ls -v queries/*.cypher`; do
    echo -ne "-- Running query $query\033[K\r"; echo
     # Run the query 5 times sequentially
    for i in {1..5}; do
      echo -ne "\033[K---- Running iteration $i\r"

      # Specify the output folder
      result_dir="results/$1/query/iter$i/$(basename $query .cypher)/"
      mkdir -p $result_dir

      # Timeout if query exceeds 6 hours
      timeout 21600 $NEO4J_HOME/bin/neo4j-shell -file $query > $result_dir"result.txt"

      # it timed out :(! break out of for loop
      if [[ $? -ne 0 ]]; then 
        echo timedout > $result_dir"result.txt"; break;
      fi
    done
  done
}

loadDB
