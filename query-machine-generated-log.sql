-- Q1.1: What is the CPU/network utilization for each web server since midnight?

SELECT machine_name,
       MIN(cpu) AS cpu_min,
       MAX(cpu) AS cpu_max,
       AVG(cpu) AS cpu_avg,
       MIN(net_in) AS net_in_min,
       MAX(net_in) AS net_in_max,
       AVG(net_in) AS net_in_avg,
       MIN(net_out) AS net_out_min,
       MAX(net_out) AS net_out_max,
       AVG(net_out) AS net_out_avg
FROM (
  SELECT machine_name,
         COALESCE(cpu_user, 0.0) AS cpu,
         COALESCE(bytes_in, 0.0) AS net_in,
         COALESCE(bytes_out, 0.0) AS net_out
  FROM logs1
  WHERE machine_name IN ('anansi','aragog','urd')
    AND log_time >= TIMESTAMP '2017-01-11 00:00:00'
) AS r
GROUP BY machine_name;


-- Q1.2: Which computer lab machines have been offline in the past day?

SELECT machine_name,
       log_time
FROM logs1
WHERE (machine_name LIKE 'cslab%' OR
       machine_name LIKE 'mslab%')
  AND load_one IS NULL
  AND log_time >= TIMESTAMP '2017-01-10 00:00:00'
ORDER BY machine_name,
         log_time;


-- Q1.3: What are the hourly average metrics during the past 10 days for a specific workstation?

SELECT dt,
       hr,
       AVG(load_fifteen) AS load_fifteen_avg,
       AVG(load_five) AS load_five_avg,
       AVG(load_one) AS load_one_avg,
       AVG(mem_free) AS mem_free_avg,
       AVG(swap_free) AS swap_free_avg
FROM (
  SELECT CAST(log_time AS DATE) AS dt,
         EXTRACT(HOUR FROM log_time) AS hr,
         load_fifteen,
         load_five,
         load_one,
         mem_free,
         swap_free
  FROM logs1
  WHERE machine_name = 'babbage'
    AND load_fifteen IS NOT NULL
    AND load_five IS NOT NULL
    AND load_one IS NOT NULL
    AND mem_free IS NOT NULL
    AND swap_free IS NOT NULL
    AND log_time >= TIMESTAMP '2017-01-01 00:00:00'
) AS r
GROUP BY dt,
         hr
ORDER BY dt,
         hr;


-- Q1.4: Over 1 month, how often was each server blocked on disk I/O?

SELECT machine_name,
       COUNT(*) AS spikes
FROM logs1
WHERE machine_group = 'Servers'
  AND cpu_wio > 0.99
  AND log_time >= TIMESTAMP '2016-12-01 00:00:00'
  AND log_time < TIMESTAMP '2017-01-01 00:00:00'
GROUP BY machine_name
ORDER BY spikes DESC
LIMIT 10;


-- Q1.5: Which externally reachable VMs have run low on memory?

SELECT machine_name,
       dt,
       MIN(mem_free) AS mem_free_min
FROM (
  SELECT machine_name,
         CAST(log_time AS DATE) AS dt,
         mem_free
  FROM logs1
  WHERE machine_group = 'DMZ'
    AND mem_free IS NOT NULL
) AS r
GROUP BY machine_name,
         dt
HAVING MIN(mem_free) < 10000
ORDER BY machine_name,
         dt;


-- Q1.6: What is the total hourly network traffic across all file servers?

SELECT dt,
       hr,
       SUM(net_in) AS net_in_sum,
       SUM(net_out) AS net_out_sum,
       SUM(net_in) + SUM(net_out) AS both_sum
FROM (
  SELECT CAST(log_time AS DATE) AS dt,
         EXTRACT(HOUR FROM log_time) AS hr,
         COALESCE(bytes_in, 0.0) / 1000000000.0 AS net_in,
         COALESCE(bytes_out, 0.0) / 1000000000.0 AS net_out
  FROM logs1
  WHERE machine_name IN ('allsorts','andes','bigred','blackjack','bonbon',
      'cadbury','chiclets','cotton','crows','dove','fireball','hearts','huey',
      'lindt','milkduds','milkyway','mnm','necco','nerds','orbit','peeps',
      'poprocks','razzles','runts','smarties','smuggler','spree','stride',
      'tootsie','trident','wrigley','york')
) AS r
GROUP BY dt,
         hr
ORDER BY both_sum DESC
LIMIT 10;


-- Q2.1: Which requests have caused server errors within the past 2 weeks?

SELECT *
FROM logs2
WHERE status_code >= 500
  AND log_time >= TIMESTAMP '2012-12-18 00:00:00'
ORDER BY log_time;


-- Q2.2: During a specific 2-week period, was the user password file leaked?

SELECT *
FROM logs2
WHERE status_code >= 200
  AND status_code < 300
  AND request LIKE '%/etc/passwd%'
  AND log_time >= TIMESTAMP '2012-05-06 00:00:00'
  AND log_time < TIMESTAMP '2012-05-20 00:00:00';


-- Q2.3: What was the average path depth for top-level requests in the past month?

SELECT top_level,
       AVG(LENGTH(request) - LENGTH(REPLACE(request, '/', ''))) AS depth_avg
FROM (
  SELECT SUBSTRING(request FROM 1 FOR len) AS top_level,
         request
  FROM (
    SELECT POSITION(SUBSTRING(request FROM 2), '/') AS len,
           request
    FROM logs2
    WHERE status_code >= 200
      AND status_code < 300
      AND log_time >= TIMESTAMP '2012-12-01 00:00:00'
  ) AS r
  WHERE len > 0
) AS s
WHERE top_level IN ('/about','/courses','/degrees','/events',
                    '/grad','/industry','/news','/people',
                    '/publications','/research','/teaching','/ugrad')
GROUP BY top_level
ORDER BY top_level;


-- Q2.4: During the last 3 months, which clients have made an excessive number of requests?

SELECT client_ip,
       COUNT(*) AS num_requests
FROM logs2
WHERE log_time >= TIMESTAMP '2012-10-01 00:00:00'
GROUP BY client_ip
HAVING COUNT(*) >= 100000
ORDER BY num_requests DESC;


-- Q2.5: What are the daily unique visitors?

SELECT dt,
       COUNT(DISTINCT client_ip)
FROM (
  SELECT CAST(log_time AS DATE) AS dt,
         client_ip
  FROM logs2
) AS r
GROUP BY dt
ORDER BY dt;


-- Q2.6: What are the average and maximum data transfer rates (Gbps)?

SELECT AVG(transfer) / 125000000.0 AS transfer_avg,
       MAX(transfer) / 125000000.0 AS transfer_max
FROM (
  SELECT log_time,
         SUM(object_size) AS transfer
  FROM logs2
  GROUP BY log_time
) AS r;


-- Q3.1: Did the indoor temperature reach freezing over the weekend?

SELECT *
FROM logs3
WHERE event_type = 'temperature'
  AND event_value <= 32.0
  AND log_time >= '2019-11-29 17:00:00.000';


-- Q3.4: Over the past 6 months, how frequently were each door opened?

SELECT device_name,
       device_floor,
       COUNT(*) AS ct
FROM logs3
WHERE event_type = 'door_open'
  AND log_time >= '2019-06-01 00:00:00.000'
GROUP BY device_name,
         device_floor
ORDER BY ct DESC;


-- Q3.5: Where in the building do large temperature variations occur in winter and summer?

WITH temperature AS (
  SELECT dt,
         device_name,
         device_type,
         device_floor
  FROM (
    SELECT dt,
           hr,
           device_name,
           device_type,
           device_floor,
           AVG(event_value) AS temperature_hourly_avg
    FROM (
      SELECT CAST(log_time AS DATE) AS dt,
             EXTRACT(HOUR FROM log_time) AS hr,
             device_name,
             device_type,
             device_floor,
             event_value
      FROM logs3
      WHERE event_type = 'temperature'
    ) AS r
    GROUP BY dt,
             hr,
             device_name,
             device_type,
             device_floor
  ) AS s
  GROUP BY dt,
           device_name,
           device_type,
           device_floor
  HAVING MAX(temperature_hourly_avg) - MIN(temperature_hourly_avg) >= 25.0
)
SELECT DISTINCT device_name,
       device_type,
       device_floor,
       'WINTER'
FROM temperature
WHERE dt >= DATE '2018-12-01'
  AND dt < DATE '2019-03-01'
UNION
SELECT DISTINCT device_name,
       device_type,
       device_floor,
       'SUMMER'
FROM temperature
WHERE dt >= DATE '2019-06-01'
  AND dt < DATE '2019-09-01';


-- Q3.6: For each device category, what are the monthly power consumption metrics?

SELECT yr,
       mo,
       SUM(coffee_hourly_avg) AS coffee_monthly_sum,
       AVG(coffee_hourly_avg) AS coffee_monthly_avg,
       SUM(printer_hourly_avg) AS printer_monthly_sum,
       AVG(printer_hourly_avg) AS printer_monthly_avg,
       SUM(projector_hourly_avg) AS projector_monthly_sum,
       AVG(projector_hourly_avg) AS projector_monthly_avg,
       SUM(vending_hourly_avg) AS vending_monthly_sum,
       AVG(vending_hourly_avg) AS vending_monthly_avg
FROM (
  SELECT dt,
         yr,
         mo,
         hr,
         AVG(coffee) AS coffee_hourly_avg,
         AVG(printer) AS printer_hourly_avg,
         AVG(projector) AS projector_hourly_avg,
         AVG(vending) AS vending_hourly_avg
  FROM (
    SELECT CAST(log_time AS DATE) AS dt,
           EXTRACT(YEAR FROM log_time) AS yr,
           EXTRACT(MONTH FROM log_time) AS mo,
           EXTRACT(HOUR FROM log_time) AS hr,
           CASE WHEN device_name LIKE 'coffee%' THEN event_value END AS coffee,
           CASE WHEN device_name LIKE 'printer%' THEN event_value END AS printer,
           CASE WHEN device_name LIKE 'projector%' THEN event_value END AS projector,
           CASE WHEN device_name LIKE 'vending%' THEN event_value END AS vending
    FROM logs3
    WHERE device_type = 'meter'
  ) AS r
  GROUP BY dt,
           yr,
           mo,
           hr
) AS s
GROUP BY yr,
         mo
ORDER BY yr,
         mo;
