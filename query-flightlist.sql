SELECT avg(geoDistance(longitude_1, latitude_1, longitude_2, latitude_2)) FROM opensky;

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

SELECT
    toMonday(day) AS k,
    count() AS c,
    bar(c, 0, 10000, 100) AS bar
FROM opensky
WHERE origin IN ('UUEE', 'UUDD', 'UUWW')
GROUP BY k
ORDER BY k ASC;
