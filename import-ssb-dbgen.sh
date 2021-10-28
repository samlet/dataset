#!/bin/bash
export PATH=~/workspace/olap/clickhouse:$PATH
clickhouse client --query "INSERT INTO customer FORMAT CSV" < ssb-dbgen/customer.tbl
clickhouse client --query "INSERT INTO part FORMAT CSV" < ssb-dbgen/part.tbl
clickhouse client --query "INSERT INTO supplier FORMAT CSV" < ssb-dbgen/supplier.tbl
clickhouse client --query "INSERT INTO lineorder FORMAT CSV" < ssb-dbgen/lineorder.tbl
