#!/bin/bash

CONTAINER_NAME=cloudera-quickstart
OUTPUT_DIR='$(pwd)/results'
FILTER_PIPELINE="grep -v '^WARN'"

# Create output directory and dump query results to respective .log files:
docker-compose exec -T $CONTAINER_NAME bash -c "rm -fr ./results && mkdir results"
docker-compose exec -T $CONTAINER_NAME bash -c "hive -e 'select * from product_histogram;' | $FILTER_PIPELINE > $OUTPUT_DIR/product_histogram.log"
docker-compose exec -T $CONTAINER_NAME bash -c "hive -e 'select * from views_per_hour;' | $FILTER_PIPELINE > $OUTPUT_DIR/views_per_hour.log"
docker-compose exec -T $CONTAINER_NAME bash -c "hive -e 'select * from os_histogram;' | $FILTER_PIPELINE > $OUTPUT_DIR/os_histogram.log"

# Copy files from sandbox:
rm -fr results && mkdir results
docker container cp $CONTAINER_NAME:/analytics/results .
