#!/bin/bash

CONTAINER_NAME=cloudera-quickstart

# Copy log file to be ingested, into HDFS:
docker-compose exec -T $CONTAINER_NAME hadoop fs -mkdir -p /user/hive/warehouse/log
docker-compose exec -T $CONTAINER_NAME hadoop fs -copyFromLocal ./access.log /user/hive/warehouse/log/access.log

#Create table and handy views using Hive CLI:
docker-compose exec -T cloudera-quickstart hive << EOF
    drop table if exists log_intermediario;
    CREATE EXTERNAL TABLE log_intermediario (
    ip STRING,
    data STRING,
    metodo STRING,
    url STRING,
    http_versao STRING,
    codigo1 STRING,
    codigo2 STRING,
    traco STRING,
    Sistema_operacional STRING)

    ROW FORMAT SERDE 'org.apache.hadoop.hive.contrib.serde2.RegexSerDe' WITH SERDEPROPERTIES ( 'input.regex' = '([^ ]*) - - \\\[([^\\\]]*)\\\] "([^\ ]*) ([^\ ]*) ([^\ ]*)" (\\\d*) (\\\d*) "([^"]*)" "([^"]*)"',
    'output.format.string' = "%1$$s %2$$s %3$$s %4$$s %5$$s %6$$s %7$$s %8$$s %9$$s")
    LOCATION '/user/hive/warehouse/log';

    drop view if exists product_histogram;
    create view product_histogram as
    select regexp_replace(regexp_extract(result.url, '^.*\/product\/(.*)$', 1), '%20', ' ') as product, result.views as views
    from (
        select l.url, count(*) as views
        from log_intermediario as l
        group by l.url
        having instr(l.url, 'product') > 0
        order by views DESC
    ) as result;
    
    drop view if exists views_per_hour;
    create view views_per_hour as
    select result.hour_ as hour, count(*) as views
    from (
        select hour(regexp_extract(l.data, '^.*\\\d{2}\/\\\w{2,3}\/\\\d{4}\:(\\\d{2}\:\\\d{2}\:\\\d{2}).*$', 1)) as hour_
        from log_intermediario as l
    ) as result
    group by result.hour_;

    drop view if exists os_histogram;
    create view os_histogram as
    select result.base_distribution, sum(result.views) as views
    from (
        select regexp_extract(l.sistema_operacional, '\\\(([^\\\(\\\)\;]+).*\\\)', 1) as base_distribution, count(*) as views
        from log_intermediario as l
        group by l.sistema_operacional
    ) as result
    group by result.base_distribution
    order by views DESC;
EOF
