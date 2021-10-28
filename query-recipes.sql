SELECT
    arrayJoin(NER) AS k,
    count() AS c
FROM recipes
GROUP BY k
ORDER BY c DESC
LIMIT 50

SELECT
    title,
    length(NER),
    length(directions)
FROM recipes
WHERE has(NER, 'strawberry')
ORDER BY length(directions) DESC
LIMIT 10

SELECT arrayJoin(directions)
FROM recipes
WHERE title = 'Chocolate-Strawberry-Orange Wedding Cake'
