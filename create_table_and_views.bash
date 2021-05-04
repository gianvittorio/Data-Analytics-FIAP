#!/bin/bash

docker-compose exec -T cloudera-quickstart hive << EOF
    drop view if exists product_histogram;
    create view product_histogram as
    select regexp_replace(regexp_extract(result.url, '^.*\/product\/(.*)$', 1), '%20', ' ') as product, result.views as views
    from (
        select l.url, count(*) as views
        from log_intermediario as l
        where instr(l.url, 'product') > 0
        group by l.url
        order by views DESC
    ) as result;
    
    drop view if exists views_per_hour;
    create view views_per_hour as
    select result.hour_ as hour, count(*) as views
    from (
        select hour(regexp_extract(l.data, '^.*\\d{2}\/\\w{2,3}\/\\d{4}\:(\\d{2}\:\\d{2}\:\\d{2}).*$', 1)) as hour_
        from log_intermediario as l
    ) as result
    group by result.hour_;

    drop view if exists os_histogram;
    create view os_histogram as
    select result.base_distribution, sum(result.views) as views
    from (
        select regexp_extract(l.sistema_operacional, '\\(([^\\(\\)\;]+).*\\)', 1) as base_distribution, count(*) as views
        from log_intermediario as l
        group by l.sistema_operacional
    ) as result
    group by result.base_distribution
    order by views DESC;
EOF