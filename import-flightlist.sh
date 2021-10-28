#!/bin/bash
export PATH=~/workspace/olap/clickhouse:$PATH
ls -1 ~/tools/bigdata/dataset/flightlist_*.csv.gz | xargs -P100 -I{} bash -c 'gzip -c -d "{}" | clickhouse client --date_time_input_format best_effort --query "INSERT INTO opensky FORMAT CSVWithNames"'
