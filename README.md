# README.md
## dataset
* facts
    - 供应商: ssb
    - 房地产: uk-property
    - 旅行: flightlist(航空), ontime(航空), nyc-taxi(出租)
    - 网站: visits
    - 餐饮业: 食谱(recipes), 菜单(menus)
    - 电信: cell-towers
    - 硬件: machine-generated-log
    - 电商: user-behavior

* faker:
    - gmall-mock
    - user profile

## create
```bash
$ clickhouse-client --queries-file create-menus.sql 
```

        