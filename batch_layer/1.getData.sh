#!/bin/bash
# Downloads data from the data.cityofchicago website and puts it into an hdfs system
curl https://data.cityofchicago.org/api/views/ijzp-q8t2/rows.csv | hdfs dfs -put -f - /tmp/rohithj/chicagocrime.csv
