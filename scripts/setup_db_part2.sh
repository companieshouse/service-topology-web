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

#
#
# Create Node-type Table
#
#

# Create table
aws rds-data execute-statement \
    --resource-arn "$RESOURCE_ARN" \
    --database "$DB" \
    --secret-arn "$SECRET_ARN" \
    --sql \
    "CREATE TABLE IF NOT EXISTS node_types (
       id int NOT NULL auto_increment,
       name varchar(40) NOT NULL UNIQUE default '',
       shape varchar(40) NOT NULL UNIQUE default 'Sphere',
       material varchar(40) NOT NULL UNIQUE default 'MeshStandard',
       colour varchar(25) NOT NULL default '#1b1c1d',
       emissive varchar(25) NOT NULL default '#42423e',
       metalness decimal(4,3) NOT NULL default 1,
       roughness decimal(4,3) NOT NULL default 0.5,
       PRIMARY KEY (id)
     );"

# Add a default shape
aws rds-data execute-statement \
  --resource-arn "$RESOURCE_ARN" \
  --database "$DB" \
  --secret-arn "$SECRET_ARN" \
  --sql \
  "INSERT INTO node_types (name)
    VALUES
        ('default');"

#
#
# Node Table updates for node
#
#

# Add node-type ID field to nodes
aws rds-data execute-statement \
    --resource-arn "$RESOURCE_ARN" \
    --database "$DB" \
    --secret-arn "$SECRET_ARN" \
    --sql \
    "ALTER TABLE nodes
    ADD node_type_id int;"

# Set all node types to default
aws rds-data execute-statement \
    --resource-arn "$RESOURCE_ARN" \
    --database "$DB" \
    --secret-arn "$SECRET_ARN" \
    --sql \
    "UPDATE nodes
    SET node_type_id = 1;"

# Create FK constraint
aws rds-data execute-statement \
    --resource-arn "$RESOURCE_ARN" \
    --database "$DB" \
    --secret-arn "$SECRET_ARN" \
    --sql \
    "ALTER TABLE nodes ADD CONSTRAINT fk_node_type_id FOREIGN KEY (node_type_id) REFERENCES node_types (id);"

# Drop colour field from nodes table
aws rds-data execute-statement \
    --resource-arn "$RESOURCE_ARN" \
    --database "$DB" \
    --secret-arn "$SECRET_ARN" \
    --sql \
    "ALTER TABLE nodes
    DROP COLUMN colour;"
