#!/bin/bash
export PATH=~/workspace/olap/clickhouse:$PATH
clickhouse client --queries-file convert-ssb.sql

