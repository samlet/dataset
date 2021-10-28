#!/bin/bash
export PATH=~/workspace/olap/clickhouse:$PATH
clickhouse client --query "INSERT INTO tutorial.visits_v1 FORMAT TSV" --max_insert_block_size=100000 < ~/tools/bigdata/dataset/visits_v1.tsv

