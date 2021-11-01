-- $ clickhouse-client --queries-file create-machine-generated-log.sql
CREATE DATABASE mgbench;


CREATE TABLE mgbench.logs1 (
  log_time      DateTime,
  machine_name  LowCardinality(String),
  machine_group LowCardinality(String),
  cpu_idle      Nullable(Float32),
  cpu_nice      Nullable(Float32),
  cpu_system    Nullable(Float32),
  cpu_user      Nullable(Float32),
  cpu_wio       Nullable(Float32),
  disk_free     Nullable(Float32),
  disk_total    Nullable(Float32),
  part_max_used Nullable(Float32),
  load_fifteen  Nullable(Float32),
  load_five     Nullable(Float32),
  load_one      Nullable(Float32),
  mem_buffers   Nullable(Float32),
  mem_cached    Nullable(Float32),
  mem_free      Nullable(Float32),
  mem_shared    Nullable(Float32),
  swap_free     Nullable(Float32),
  bytes_in      Nullable(Float32),
  bytes_out     Nullable(Float32)
)
ENGINE = MergeTree()
ORDER BY (machine_group, machine_name, log_time);


CREATE TABLE mgbench.logs2 (
  log_time    DateTime,
  client_ip   IPv4,
  request     String,
  status_code UInt16,
  object_size UInt64
)
ENGINE = MergeTree()
ORDER BY log_time;


CREATE TABLE mgbench.logs3 (
  log_time     DateTime64,
  device_id    FixedString(15),
  device_name  LowCardinality(String),
  device_type  LowCardinality(String),
  device_floor UInt8,
  event_type   LowCardinality(String),
  event_unit   FixedString(1),
  event_value  Nullable(Float32)
)
ENGINE = MergeTree()
ORDER BY (event_type, log_time);
