#!/bin/bash
export PATH=~/workspace/olap/clickhouse:$PATH
clickhouse client --queries-file ./create-ssb-dbgen.sql
