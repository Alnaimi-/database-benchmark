#SqlGraph
A set of scripts to help benchmark an interpreted implementation of the [SQLGraph][1] paper using the LDBC Social Network data which can be found on github [ldbc_snb_datagen][2].

This benchmarking was conducted as part of a comparative study between three different database technologies, namely: Vertica; SqlGraph, running on MySQL; and Neo4J. The source code to these, together with a GUI style R-shinyapp representation of acquired results can be found under the master branch.

##Script Structure
```html
sqlgraph\script\                 : Contains the script files to be executed
        \script\benchmark.sh     : Utility script to benchmark different datasets
        \script\populateSQL.sh   : Main script for data crunching and migration
        \script\gstat            : Modified version of dstat w. 100ms granularity
        \script\normalisy.py     : a) normalises entity ids to avoid key clash
        \script\propertygraph.sh : b) converts the raw data to sqlgraph format
sqlgraph\resources\              : Contains script utilities
		\resources\ldbc.ddl      : Interpreted SqlGraph schema
		\resources\my.cnf        : MySQL config parameters
		\resources\queries\      : Contains the sql queries to be benchmarked
```

##Quick Start
To run the scripts simply cd into the fold 'script' and enter:

```bash
sudo ./populateSQL.sh --help # If you wish to convert and migrate raw data to sqlgraph
sudo ./benchmark.sh          # If you wish to run the benchmark across multiple datasets
						     # * Remember to edit constants according to user preference
```

## Observations
#### SQL schema
As the authors of SQLGraph has neither described the implementation nor open-sourced the code for the described work, many assumptions where made, including about the structure or in this case the *database schema*. 

The [ldbc-snb][1] dataset was chosen due to it's nature to produce tangible data representitive to that of a real-world scenario. However and contrary to the dataset described in SQLGraph, the generated dataset contains several connected entities. This introduces the need for further indexing to make the benchmarks performed on the framework fairer or on a more level plane to that of other framerworks. This additional step however adds to the complexity and time requirement for data migration unless key checks are disabled.

Additionally it is worth mentioning that while the SQLGraph paper mentions the use of [Secondary Indexes and Generated Virtual Columns][3] on vertex attributes (now stored as JSON format), experimentation with this technique seemed to yield no noticeable improvements.

#### SQL indexing strategy (Hash vs. B-Trees)
MySQL offers for different indexing techniques to retrieve specific column values quickly. SQLGraph vaguely mentions the different columns that have been indexed, but as this benchmark also makes use of a different dataset (*ldbcgen*), indexes has been added where seen fit. Most indexes uses are hash-bashed. Below is a brief overview of hash vs. b-trees.

**Hash**

* O(1) access 
* Can't select ranges - may be a worst case of O(n)
* Hash indexing works around pre-defined hash size (this can decay and require rehashing for optimal result which can be expensive)

**B-Trees**

* O(log(n)) access
* Easier to grow and maintain, scales better (though some research around this area has been made for "efficient" scalable hash algorithms; see Controlled/Replication Under Scalable Hashing)

#### Server spec

The MySQL framework similar to Neo4J was tested under a modified version of [HP Proliant DL 980 G7][4] which was further altered to add an additional 2TB of Ram and CPU Cores. 

```
8 x Intel(R) Xeon(R) CPU 4870 E7 (10 real cores each @ 2.40 GHz)
L1 cache: 320 kB
L2 cache: 2560 kB
L3 cache: 30 MB
RAM: 4TB @ 1066MHz
```

Running Ubuntu 14.04 LTS With Neo4J 2.3.4 and MySQL 5.8.

#### MySQL tuning
The MySQL data migration is a big chunk of the benchmark process. Importing data into innodb using the default 'LOAD INFILE' would take up to 60 hours on the 100GB ldbc dataset, specifically when this would translate into approx. 460GB in SQLGraph form. 

For the reason highlighted above; mysqld parameters were altered to better reflect the environment for which the process is taking place, and to help shave off time. These parameters can be found under *resources/my.cnf*, and are explained below:


- **innodb_buffer_pool_size** : This parameter dictates the cache buffer size for caches tables and indexes. During migration data is loaded into cache to reduce disk io. The larger value - the more data and indexes can be stored in logical memory. Ideally, this parameter should be set to as high as possible, leaving enough memory for other processes to run on the server without excessive paging. On dedicated servers this param is often set to 80% of all available ram. The larger value - the more innodb acts as in-memory database. To reduce contention for data structures among current operations - one can split the buffer pool into multiple parts. See below point. One can examine the hit rate to better determine a suitable value for this parameter.  Below query displays the effectiveness of data retrieval. It is recommended to have a hit rate of higher than 95%, a lesser value indicates for the need of bigger buffer pool.  ```SELECT round ((P1.variable_value / (P1.variable_value + P2.variable_value) * 100), 10) AS hit_ratio, P2.variable_value_reads, P1.variable_value AS memory_reads FROM information_schema.GLOBAL_STATUS P1, information_schema.GLOBAL_STATUS P2 WHERE P1.variable_name = 'innodb_buffer_pool_read_requests' AND P2.variable_name = 'innodb_buffer_pool_reads';```
- **innodb_buffer_pool_instances**: This value can be altered to tell innodb the number of regions that the buffer pool should be divided into. A higher value allocates a higher number of 'workers'. With systems in the gigabyte range, this value may help improve concurrency for data reads and writes. Each pool acts as a independent entity from the other and therefore manages its own free lists, flushes and LRUs, and any other data structures connected to a buffer pool.  
- **innodb_log_file_size** : This parameter dictates the size of the log file on disk. A general rule of thumb to follow is that bigger workloads to io require bigger file size, and the default 5MB is often not enough. The idea is that you need a large enough size to allow for innodb to optimize io, but not too large where recovery time takes too long. A good way to approximate the needed log file size is to examine the changes of the log sequence number retrieved from ```SHOW ENGINE INNODB STATUS;```
- **innodb_log_buffer_size** : The log buffer size is associated with the log file size parameter above. This allows transactions to run without the need to write to disk. Increasing this parameter on dedicated servers can improve migration time by saving disk io. With the command ```SHOW GLOBAL STATUS LIKE 'innodb_log_waits';``` one can examine the number of times the buffer size was too small and data had to be written to disk before continuing. 
- **innodb_flush_log_at_trx** : The options here are 0, 1 and 2. If the value is set to 0, the log buffer is written out once per second and the log file is flushed however no interference during transaction commit. If the value is set to 1 (which is default), then the buffer is written out at each transaction with the log file flushed - This is required for full ACID compliance. Finally, when the value is set to 2, the buffer is written out to file at each commit but the flush to disk operation is only performed once per second on the log file.  While better performance can be achieved by setting this parameter to a value different from 1, one must consider the possibility of a seconds worth of transaction data to be lost during a crash. With a value of 2, only an operating system crash or a power outage can erase the last second of transactions. InnoDB's crash recovery works regardless of the value. One may consider to also try using the Unix command hdparm to disable the caching of disk writes in hardware caches as per recommended on mysql documentation [innodb_flush_log_at_trx][5].

Furthermore, autocommit, unique and foreign key checks and binary logging are disabled. In the case of autocommit, this means that changes to transaction-safe tables are not made immediately, thus requiring a commit statement at the end of a transaction to store any changes.

PS. Above described mysqdl parameters are reset to default MySQL config settings before query benchmarking as they may otherwise benefit execution times.  

#### SQL queries
It's important to note that all SQL queries were written with regards to cross-framework compatibility. For this reason MySQL - specific operations have been avoided to best of possibility. While the SQLGraph paper makes use of inline views (i.e. the with keyword), most operations in this work follow ANSI standard join operations. While join operations are resource and time consuming, especially on larger sets, such an approach should not differ from the mentioned work as query engine should result in the same traversal path as that of a with - where approach.

**Possible improvements**
Many columns in the described primary incoming/outcoming tables are left non-indexed. This can be demonstrated in query 2 where innodb is required to extract the and compare the column values in order to search for the "knows" relation.

Additionally, query 7 exhibits from the first/least/max item in group problem. Temporary data massaging was employed in the query select to get around this issue. This is further explained in *resources/queries/query7.sql*


#### Todo
The Raw to SqlGraph transformation process in *propertygraph.py* can be hastened if the different entity groups are made to run in parallel. More specifically these entity groups are independent from each other and as such the primary / secondary adjacency translation which depends on a hashset implementation can be ran in parallel.

------

* Suggestions for improvement or contribution to the code base are sincerely welcome.

  [1]: research.google.com/pubs/archive/43287.pdf"An Efficient Relational-Based Property Graph Store"
[2]: https://github.com/ldbc/ldbc_snb_datagen
[3]: https://dev.mysql.com/doc/refman/5.7/en/create-table-secondary-indexes-virtual-columns.html
[4]: https://www.hpe.com/h20195/v2/getpdf.aspx/c04128191.pdf?ver=43
[5]: http://dev.mysql.com/doc/refman/5.5/en/innodb-parameters.html#sysvar_innodb_flush_log_at_trx_commit