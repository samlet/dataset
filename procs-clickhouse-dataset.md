# procs-clickhouse-dataset.md
+ uk_price_paid

```sql
select toYear(date) AS year, price from uk_price_paid limit 10
select toYear(date) AS year, toMonth(date) as month, district, price from uk_price_paid limit 10

-- The Most Expensive Neighborhoods¶
SELECT
    town,
    district,
    count() AS c,
    round(avg(price)) AS price,
    bar(price, 0, 5000000, 100)
FROM uk_price_paid
WHERE date >= '2020-01-01'
GROUP BY
    town,
    district
HAVING c >= 100
ORDER BY price DESC
LIMIT 100;
```

## prjection
```sql
# Create an aggregate projection by dimensions toYear(date), district, town:

ALTER TABLE uk_price_paid
    ADD PROJECTION projection_by_year_district_town
    (
        SELECT
            toYear(date),
            district,
            town,
            avg(price),
            sum(price),
            count()
        GROUP BY
            toYear(date),
            district,
            town
    );

# Populate the projection for existing data (without it projection will be created for only newly inserted data):
ALTER TABLE uk_price_paid
    MATERIALIZE PROJECTION projection_by_year_district_town
SETTINGS mutations_sync = 1;

# Enable projections for selects:
SET allow_experimental_projection_optimization = 1;

# Average Price Per Year
SELECT
    toYear(date) AS year,
    round(avg(price)) AS price,
    bar(price, 0, 1000000, 80)
FROM uk_price_paid
GROUP BY year
ORDER BY year ASC;

```

+ opensky

```sql
SELECT count() FROM opensky;
SELECT formatReadableSize(total_bytes) FROM system.tables WHERE name = 'opensky';
SELECT formatReadableQuantity(sum(geoDistance(longitude_1, latitude_1, longitude_2, latitude_2)) / 1000) FROM opensky;

-- Average flight distance is around 1000 km.
SELECT avg(geoDistance(longitude_1, latitude_1, longitude_2, latitude_2)) FROM opensky;

-- Most busy origin airports and the average distance seen¶
-- 最繁忙的始发机场和看到的平均距离
SELECT
    origin,
    count(),
    round(avg(geoDistance(longitude_1, latitude_1, longitude_2, latitude_2))) AS distance,
    bar(distance, 0, 10000000, 100) AS bar
FROM opensky
WHERE origin != ''
GROUP BY origin
ORDER BY count() DESC
LIMIT 100;

-- 每周从莫斯科三大机场起飞的航班数量
SELECT
    toMonday(day) AS k,
    count() AS c,
    bar(c, 0, 10000, 100) AS bar
FROM opensky
WHERE origin IN ('UUEE', 'UUDD', 'UUWW')
GROUP BY k
ORDER BY k ASC;

```

+ recipes

```sql
-- In this example we learn how to use arrayJoin function to expand an array into a set of rows.
SELECT
    arrayJoin(NER) AS k,
    count() AS c
FROM recipes
GROUP BY k
ORDER BY c DESC
LIMIT 50

-- The Most Complex Recipes with Strawberry 
SELECT
    title,
    length(NER),
    length(directions)
FROM recipes
WHERE has(NER, 'strawberry')
ORDER BY length(directions) DESC
LIMIT 10

-- There is a wedding cake that requires the whole 126 steps to produce! Show that directions:
SELECT arrayJoin(directions)
FROM recipes
WHERE title = 'Chocolate-Strawberry-Orange Wedding Cake'

```

+ visits
    hits 表包含所有用户在服务所涵盖的所有网站上完成的每个操作。
    visits 表包含预先构建的会话，而不是单个操作。

```sql
SELECT
    StartURL AS URL,
    AVG(Duration) AS AvgDuration
FROM tutorial.visits_v1
WHERE StartDate BETWEEN '2014-03-23' AND '2014-03-30'
GROUP BY URL
ORDER BY AvgDuration DESC
LIMIT 10

SELECT
    sum(Sign) AS visits,
    sumIf(Sign, has(Goals.ID, 1105530)) AS goal_visits,
    (100. * goal_visits) / visits AS goal_percent
FROM tutorial.visits_v1
WHERE (CounterID = 912887) AND (toYYYYMM(StartDate) = 201403) AND (domain(StartURL) = 'yandex.ru')

```

