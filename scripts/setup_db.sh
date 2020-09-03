#!/usr/bin/env bash

aws rds-data execute-statement \
    --resource-arn "$RESOURCE_ARN" \
    --database "$DB" \
    --secret-arn "$SECRET_ARN" \
    --sql \
    "CREATE TABLE IF NOT EXISTS nodes (
       id int NOT NULL auto_increment,
       name varchar(40) NOT NULL default '',
       PRIMARY KEY (id)
     );"

aws rds-data execute-statement \
    --resource-arn "$RESOURCE_ARN" \
    --database "$DB" \
    --secret-arn "$SECRET_ARN" \
    --sql \
    "CREATE TABLE IF NOT EXISTS journeys (
       id int NOT NULL auto_increment,
       name varchar(40) NOT NULL default '',
       PRIMARY KEY (id)
     );"

aws rds-data execute-statement \
    --resource-arn "$RESOURCE_ARN" \
    --database "$DB" \
    --secret-arn "$SECRET_ARN" \
    --sql \
    "CREATE TABLE IF NOT EXISTS edges (
       id int NOT NULL auto_increment,
       source int NOT NULL,
       target int NOT NULL,
       journey_id int NOT NULL,
       PRIMARY KEY (id),
       FOREIGN KEY (source) REFERENCES nodes (id),
       FOREIGN KEY (target) REFERENCES nodes (id),
       FOREIGN KEY (journey_id) REFERENCES journeys (id)
     );"
