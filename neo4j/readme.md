#Neo4J Benchmark


A set of bash style script to automate a Neo4J benchmark using the LDBC Social Network data which can be found publicly on [ldbc_snb_datagen][1]. 

This benchmarking was conducted as part of a comparative study between three different database technologies, namely: Vertica; SqlGraph, running on MySQL; and Neo4J. The source code to these, together with a GUI style R-shinyapp representation of the acquired results can be found under the master branch.

##Script Structure
```html
neo4j\benchmark.sh          : Utility script to benchmark different datasets
     \neo4j-ldbc-benchmark\ : Main directory for benchmark script (1).
     \neo4j-ldbc-ingester\  : Main directory for ingestion script (2).
```

##Quick Start
To run the benchmark follow the numbered instructions below:

1. First make sure that both the NEO4J_HOME and LDBC_HOME environmental variables are set inside *benchmark.sh*

```bash
export NEO4J_HOME="Path to neo4j installation dir"
export LDBC_HOME="Path to ldbc gen data dir"
```

2. Second, make sure to deactivate the root directory for load CSV by commenting below line in $NEO4J_HOME/conf/neo4j.conf:

```html
#dbms.directories.import=import
```

3. Finally to run the main script *benchmark.sh*, simply enter:
```bash
./benchmark.sh
```

PS. Note that the bulk ingestor assumes a duplicate of the data in the folder "social_network" placed in a new folder "social_network_ingest". This is because the bulk ingestor requires the headers of the original CSV files to be changed.

##Subdirectories
####neo4j-ldbc-benchmark
```html
neo4j\neo4j-ldbc-benchmark\                   : Main directory for benchmark script.
     \neo4j-ldbc-benchmark\queries\           : Contains all cypher queries to be benchmarked.
     \neo4j-ldbc-benchmark\gstat              : Modified version of dstat w. 100ms granularity
     \neo4j-ldbc-benchmark\query_benchmark.sh : Script to benchmark all queries across given set of data.
     \neo4j-ldbc-benchmark\split_benchmark.sh : Script to compare load_csv vs. 'neo4j-import'.
     \neo4j-ldbc-benchmark\bulk_benchmark.sh  : Script to benchmark just 'neo4j-import'. 
```

**query_benchmark.sh**
This script benchmarks all of the ldbc queries found within the 'queries' folder on a given ldbc dataset. The dataset size is set inside the script itself (as an array variable if multiple datasets are to be used). The queries are ran 5 times to acquire an average of the execution time. It's worth noting that optimasations such as "warming the cache" and parameter preparement for query plan caching are implemented to the best of our knowledge. For further framework specific improvements please see the Neo4J tuning section below.

This file has the additional parameter option '-h' to allow for multiphop benchmarking for friends, friends of friends, etc. up to and including the depth of 5.

**bulk_benchmark.sh**
This script benchmarks the neo4j-importer to acquire an average time for ingesting and migrating the data from csv file to graph.db - this is done over a 10 iterations for each dataset. 

**split_benchmark.sh**
This script, similar to the above, benchmarks the time it takes to migrate the data to a readily usable format. However this ingests half the data with the neo4j-importer and the other half with load_csv. The data is split utilising datasplit.py found inside neo4j-ldbc-ingester directory.

####neo4j-ldbc-ingester
```html
neo4j\neo4j-ldbc-ingester\                     : Main directory for ingestion script.
     \neo4j-ldbc-ingester\ldbcdatastructures\ : Python class files to represent the different ldbc datastructures.
     \neo4j-ldbc-ingester\ldbcIO\             : Utility files to handle data io for csv files.
     \neo4j-ldbc-ingester\resources\          : Template files for ingestion.
     \neo4j-ldbc-ingester\datasplit.py        : Splits the ldbc nodes and relations into half, see further below.
     \neo4j-ldbc-ingester\Neo4jMerger.py      : Groups the person entity and related properties to one csv.
     \neo4j-ldbc-ingester\change_headers.sh   : Changes the heads of the csv file to better fit the ldbc structure. 
     \neo4j-ldbc-ingester\bulk_ingester.sh    : Runs the neo4j-importer. Further explained below.
     \neo4j-ldbc-ingester\populate_neo4j.sh   : Governs the ldbc ingestion process. Further explained below.
```

**change_headers.sh**
This script files converts the original ldbc csv header format to neo4j such that it may be utilised by the neo4j-importer (including namespace and type). 

Note again: It's recommended that this script is ran on a copy of the original ldbc data as it will permanently alter the structure of the data and as such should be handled with precaution.

**bulk_ingester.sh**
This script file executes the neo4j-importer with the correct set of parameters tailored for the ldbc data structure. It's recommended to let populate_neo4j.sh below handle this script - unless you know what you are doing.

**populate_neo4j.sh**
This script file handles the overall ingestion process, allowing the user to create new neo4j stores via load_csv and the bulk ingester, or a combination of the two (see split above). To run this script, enter:


```bash
# populate with load_csv (default)
./populate_neo4j --db "path to new neo4j db" --ldbc "path to raw ldbc data"

# populate with bulk ingestor, add the option -i to change headers (only needs to be done once).
./populate_neo4j -b --db "path to new neo4j db" --ldbc "path to raw ldbc data"

# populate half the data with bulk ingestor and half with load_csv
./populate_neo4j -s --db "path to new neo4j db" --ldbc "path to raw ldbc data"
```

##Observations
#### Server Spec

The Neo4J framework was tested under a modified version of [HP Proliant DL 980 G7][4]. This server was further altered to add an additional 2TB of Ram and CPU Cores. This was important as it allowed Neo4j to function as an inmemory framework to improve query execution times. 

```
8 x Intel(R) Xeon(R) CPU 4870 E7 (10 real cores each @ 2.40 GHz)
L1 cache: 320 kB
L2 cache: 2560 kB
L3 cache: 30 MB
RAM: 4TB @ 1066MHz
```

Running Ubuntu 14.04 LTS With Neo4J 2.3.4 Community edition and java-1.7.0-openjdk.

**Note:** The community edition of Neo4j  was used as we wanted all the chosen frameworks to be freely available to the public. 2.3 was used instead of the 3+ as this is the version the LDBC queries were written for (they use HAS instead of EXISTS – this modification only happened between 2.3 -> 3).

####Neo4j Tuning

It's worth mentioning that several query, framework and java parameter tuning techniques needed to be applied to achieve a similar result to that described in the book [neo4j in action][2].
Where these alterations were most required was when running neighbour traversal (friends, friends of friends, etc.)
Such as:

```Cypher
# changing n to depth of neighbours
MATCH (:Person {id:{personId}})-[:KNOWS*1..n]->(friend:Person)
```

However, whilst similar results were reached, it was found that conditional WHERE clauses and ORDER BY statements seemed to heavily affect the execution time by several magnitudes. This even caused some queries to reach our timeout (6 hours) (see benchmark result for further info). 

As an example of its effectiveness, the tuning improved execution time of query 9 (run on the 1GB dataset) from 9742 seconds to ~400 seconds at a depth of three. 120 seconds to 26 seconds at a depth of two, and 4 seconds to 700 milliseconds at a depth of one.

--------

The above was achieved by tuning the Java virtual machine heap size and by also altering the database memory allocation plus several other parameters. The query execution time may still vary, however these spikes can be attributed to the jvm garbage collection.

Currently the heap size is set to 60GB as per recommended by the [hardware calculator][3]. It's worth to note that too large of a heap size means a longer pause in garbage collection in order to remove or delete old generation objects from memory. However there's also the trade-off of increasing the interval for which the garbage collector will be scheduled in comparison to if the heap size is too small. A sweet spot need to be found or a k axis need to be identified. 

Given different runs, execution results and garbage collection logs; We found that whether you set the heap size to 30GB or to 120GB; the true value of the execution is the same. However with smaller heap size it takes more iterations to achieve said true value. Bear in mind that we are dealing with large amounts of objects, below is an extract of full garbage collection on the 1 gigabyte dataset running query 9 with a depth of 2;

```html
2016-09-22T14:42:23.783+0100: 2091.443: 
[Full GC [PSYoungGen: 8448000K->0K(8810496K)] [ParOldGen: 14756228K->14764313K(22528000K)] 23204228K->14764313K(31338496K) 
[PSPermGen: 51699K->51699K(53248K)], 20.0876540 secs] [Times: user=1954.41 sys=9.06, real=20.09 secs] 
```
A point to note is that both the initial value and the maximum value for which the heap may grow to is set to the same size. This means that we are dealing with a static size rather than dynamic growth as the latter would introduce execution pause in the application once/if the heap fills up. 

Additionally, given the large nature of the data, the heap size and the machine which we are running on - the garbage collector model Garbage First Collector (G1) is used. This is because G1 executes multiple backgrounds threads to scan through "partitions" of the memory to find areas which contain the most garbage. This is unlike the default set model; Concurrent-Mark-Sweep (CMS) which also runs in parallel but instead has two phases, namely; marking garbage, and sweeping marked objects which can introduce an overhead with larger heap sizes.

Finally to ensure that garbage collection doesn't occur too often, the set heap size has a ratio of 1:2 between new and old gen data (in that order). This is because if the new gen area is too small, more memory would need to be passed to the old which can cause more frequent full gc (thus introducing longer pauses). A value of 1 is far too aggressive and can affect performance negatively, therefore a better middle ground was to set this value to 2.

Furthermore, several non-garbage collection related changes were made. These include;

* "Warm the cache", a technique which loads all data into memory before query execution.

* Increasing the os page buffer to the same size of the graph property store + a 20% margin to ensure that all data is or may (we found no way to monitor this) be loaded into memory at once for more frequent page hits.

* Increasing the query replan timeout. By default neo4j keeps a plan of up to 1000 query statements. This execution plan expires and is deleted from cache after a default set value of 1 second (or alternatively if 1001 queries or a convergence threshold is reached). The reason behind this has to due with the fact that a schema or even more so the data may change. However, given the fact that the benchmarked data is static - We have eliminated this timeout.

* "Cypher supports querying with parameters. This means developers don’t have to resort to string building to create a query. In addition to that, it also makes caching of execution plans much easier for Cypher." - Dana Canzano, Understanding Neo4j Query Plan Caching [Knowledge Base]. For this reason, parameters such as person id and date are exported as session variables.

* To improve initial I/O for page cache from disk - We have switched the the scheduling mechanism from deadline to noop. Although the difference between the two should be neglect-able - we are attempting to squeeze every little bit of performance here. A further point would be to further disable journalism, however this need to be practiced with caution as may lead to loss of data.

####Neo4j Ingestion
The load_csv command (originally utilised) was swapped for the bulk ingestor. This required the headers of the files to be altered (see above), but drastically sped up the ingest time (1G went from 40 mins to 1 min) and allowed the larger datasets (10G and above) to be ingested without a garbage collection overhead exception which ultimately caused a crash.

Furthermore, it also shrunk down the size of the neostore; from 8G utilising the load_csv to the mere 2.5G when utilising the 1G ldbc data. The size difference was mostly attributed to the huge log files that were generated when the former method was employed. Whilst there was an attempt to limit the log size (e.g. setting log size limit for roll arounds), the end result was unaffected. It's believed that the added IO introduced from these logs was one of the larger factors for the load_csv's slow ingestion time.

Unfortunately, the bulk ingestor only works once, generating a fresh neostore, and cannot be used to add new data to one that is already running. This means if you want to do ACID transactions or further data dumps into your neostore, you must use LOAD_CSV (limiting the dump size, running very slow, and drastically increasing the size of the neostore).

--------

* As a last note, any suggestions, improvement or contribution to the code base are sincerely welcome.

[1]: https://github.com/ldbc/ldbc_snb_datagen
[2]: https://www.manning.com/books/neo4j-in-action
[3]: https://neo4j.com/hardware-sizing/
[4]:https://www.hpe.com/h20195/v2/getpdf.aspx/c04128191.pdf?ver=43