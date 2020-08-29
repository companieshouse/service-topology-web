#!/usr/bin/env bash

# Update to allow unique node names only
aws rds-data execute-statement \
    --resource-arn "$RESOURCE_ARN" \
    --database "$DB" \
    --secret-arn "$SECRET_ARN" \
    --sql \
    "ALTER TABLE nodes
       ADD CONSTRAINT uc_name UNIQUE (name);"

# Add colour field to nodes (temporary only)
aws rds-data execute-statement \
    --resource-arn "$RESOURCE_ARN" \
    --database "$DB" \
    --secret-arn "$SECRET_ARN" \
    --sql \
    "ALTER TABLE nodes
    ADD colour varchar(25);"

# Set node colours
aws rds-data execute-statement \
    --resource-arn "$RESOURCE_ARN" \
    --database "$DB" \
    --secret-arn "$SECRET_ARN" \
    --sql \
    "UPDATE nodes
    SET colour = '#c2d31c';"
