#!/usr/bin/env bash

# Create node_types table
aws rds-data execute-statement \
    --resource-arn "$RESOURCE_ARN" \
    --database "$DB" \
    --secret-arn "$SECRET_ARN" \
    --sql \
    "CREATE TABLE IF NOT EXISTS node_types (
       id int NOT NULL auto_increment,
       name varchar(40) NOT NULL UNIQUE,
       threejs_geometry varchar(40) NOT NULL,
       threejs_geometry_attributes varchar(255) NOT NULL,
       threejs_material varchar(40) NOT NULL,
       threejs_material_attributes varchar(255) NOT NULL,
       PRIMARY KEY (id)
       );"

# Add a default record
aws rds-data execute-statement \
 --resource-arn "$RESOURCE_ARN" \
 --database "$DB" \
 --secret-arn "$SECRET_ARN" \
 --sql \
 "INSERT INTO node_types (name, threejs_geometry, threejs_geometry_attributes, threejs_material, threejs_material_attributes)
   VALUES
       ('default','SphereGeometry','4,32,32','MeshStandardMaterial',
       '{\"color\":\"#c2d31c\",\"emissive\":\"#42423e\",\"metalness\":0.5,\"roughness\":0.5}'
       );"

# Add another record
aws rds-data execute-statement \
 --resource-arn "$RESOURCE_ARN" \
 --database "$DB" \
 --secret-arn "$SECRET_ARN" \
 --sql \
 "INSERT INTO node_types (name, threejs_geometry, threejs_geometry_attributes, threejs_material, threejs_material_attributes)
   VALUES
       ('box','BoxGeometry','10,10,10','MeshStandardMaterial',
       '{\"color\":\"#ff0000\",\"emissive\":\"#000000\",\"metalness\":0.5,\"roughness\":0.5}'
       );"

# Add one more
aws rds-data execute-statement \
 --resource-arn "$RESOURCE_ARN" \
 --database "$DB" \
 --secret-arn "$SECRET_ARN" \
 --sql \
 "INSERT INTO node_types (name, threejs_geometry, threejs_geometry_attributes, threejs_material, threejs_material_attributes)
   VALUES
       ('torusknot','TorusKnotGeometry','2,3.1,103,20,13,20','MeshStandardMaterial',
       '{\"color\":\"#4dce21\",\"emissive\":\"#000000\",\"metalness\":0.5,\"roughness\":0.5}'
       );"

# Add a note_type foreign key to nodes
aws rds-data execute-statement \
   --resource-arn "$RESOURCE_ARN" \
   --database "$DB" \
   --secret-arn "$SECRET_ARN" \
   --sql \
   "ALTER TABLE nodes
   ADD node_type_id int;"

# Set node type to default on all existing nodes
aws rds-data execute-statement \
   --resource-arn "$RESOURCE_ARN" \
   --database "$DB" \
   --secret-arn "$SECRET_ARN" \
   --sql \
   "UPDATE nodes
   SET node_type_id = 1;"

# Add constraint to nodes
aws rds-data execute-statement \
   --resource-arn "$RESOURCE_ARN" \
   --database "$DB" \
   --secret-arn "$SECRET_ARN" \
   --sql \
   "ALTER TABLE nodes
   ADD CONSTRAINT fk_node_type_id FOREIGN KEY (node_type_id) REFERENCES node_types (id);"
