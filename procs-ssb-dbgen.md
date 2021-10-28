# procs-ssb-dbgen.md
```sql
SELECT
    toYear(LO_ORDERDATE) AS year,
    C_NATION,
    sum(LO_REVENUE - LO_SUPPLYCOST) AS profit,
    bar(profit, 4834240407, 10243841380, 20) AS bar
FROM lineorder_flat
WHERE C_REGION = 'AMERICA' AND S_REGION = 'AMERICA' AND (P_MFGR = 'MFGR#1' OR P_MFGR = 'MFGR#2')
GROUP BY
    year,
    C_NATION
ORDER BY
    year ASC,
    C_NATION ASC;

```

+ bar实现
    ⊕ [python - Convert a number range to another range, maintaining ratio - Stack Overflow](https://stackoverflow.com/questions/929103/convert-a-number-range-to-another-range-maintaining-ratio)

```python
OldMin,OldMax=4834240407, 10243841380
NewMin, NewMax=0,20

OldValue=5356398095
NewValue = (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin
print(NewValue) # 1.9304850417106725

OldValue=5423211196
NewValue = (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin
print(NewValue) # 2.1775017859528916
```


