#!/usr/bin/env bash

RESOURCE_ARN="arn:aws:rds:eu-west-2:169942020521:cluster:service-topology-cluster"
SECRET_ARN="arn:aws:secretsmanager:eu-west-2:169942020521:secret:rds-db-credentials/cluster-HM2KV7KVZKQLFTMI7BVFFHDO4I/admin-Uswxua"
DB="service_topology"

aws rds-data execute-statement \
    --resource-arn "$RESOURCE_ARN" \
    --database "$DB" \
    --secret-arn "$SECRET_ARN" \
    --sql \
    "
     DELETE FROM edges;
    "

aws rds-data execute-statement \
    --resource-arn "$RESOURCE_ARN" \
    --database "$DB" \
    --secret-arn "$SECRET_ARN" \
    --sql \
    "
     DELETE FROM nodes;
    "

aws rds-data execute-statement \
    --resource-arn "$RESOURCE_ARN" \
    --database "$DB" \
    --secret-arn "$SECRET_ARN" \
    --sql \
    "
     DELETE FROM journeys;
    "

aws rds-data execute-statement \
    --resource-arn "$RESOURCE_ARN" \
    --database "$DB" \
    --secret-arn "$SECRET_ARN" \
    --sql \
    "
     INSERT INTO journeys (name)
     VALUES
         ('all'),
         ('company-accounts');
    "

aws rds-data execute-statement \
   --resource-arn "$RESOURCE_ARN" \
   --database "$DB" \
   --secret-arn "$SECRET_ARN" \
   --sql \
   "
     INSERT INTO nodes (name)
     VALUES
         ('ch.gov.uk'),
         ('api.ch.gov.uk'),
         ('company-accounts.web.ch.gov.uk'),
         ('company-accounts.api.ch.gov.uk'),
         ('transactions.web.ch.gov.uk'),
         ('transactions.api.ch.gov.uk'),
         ('payments.web.ch.gov.uk'),
         ('payments.api.ch.gov.uk'),
         ('company-lookup.web.ch.gov.uk'),
         ('document-generator'),
         ('document-render-service'),
         ('document-render-assets-registry'),
         ('filing-resource-handler'),
         ('chips-filing-consumer'),
         ('chips');
    "
aws rds-data execute-statement \
    --resource-arn "$RESOURCE_ARN" \
    --database "$DB" \
    --secret-arn "$SECRET_ARN" \
    --sql \
    "
      INSERT INTO edges (source, target, journey_id)
      VALUES
          ((SELECT id FROM nodes WHERE name = 'ch.gov.uk'),
           (SELECT id FROM nodes WHERE name = 'company-accounts.web.ch.gov.uk'),
           (SELECT id FROM journeys WHERE name = 'company-accounts')),
          ((SELECT id FROM nodes WHERE name = 'company-accounts.web.ch.gov.uk'),
           (SELECT id FROM nodes WHERE name = 'company-accounts.api.ch.gov.uk'),
           (SELECT id FROM journeys WHERE name = 'company-accounts')),
          ((SELECT id FROM nodes WHERE name = 'company-accounts.web.ch.gov.uk'),
           (SELECT id FROM nodes WHERE name = 'api.ch.gov.uk'),
           (SELECT id FROM journeys WHERE name = 'company-accounts')),
          ((SELECT id FROM nodes WHERE name = 'company-accounts.web.ch.gov.uk'),
           (SELECT id FROM nodes WHERE name = 'transactions.api.ch.gov.uk'),
           (SELECT id FROM journeys WHERE name = 'company-accounts')),
          ((SELECT id FROM nodes WHERE name = 'company-accounts.web.ch.gov.uk'),
           (SELECT id FROM nodes WHERE name = 'company-lookup.web.ch.gov.uk'),
           (SELECT id FROM journeys WHERE name = 'company-accounts')),
          ((SELECT id FROM nodes WHERE name = 'company-accounts.web.ch.gov.uk'),
           (SELECT id FROM nodes WHERE name = 'transactions.web.ch.gov.uk'),
           (SELECT id FROM journeys WHERE name = 'company-accounts')),
          ((SELECT id FROM nodes WHERE name = 'company-accounts.web.ch.gov.uk'),
           (SELECT id FROM nodes WHERE name = 'payments.api.ch.gov.uk'),
           (SELECT id FROM journeys WHERE name = 'company-accounts')),
          ((SELECT id FROM nodes WHERE name = 'company-accounts.web.ch.gov.uk'),
           (SELECT id FROM nodes WHERE name = 'payments.web.ch.gov.uk'),
           (SELECT id FROM journeys WHERE name = 'company-accounts')),
          ((SELECT id FROM nodes WHERE name = 'payments.web.ch.gov.uk'),
           (SELECT id FROM nodes WHERE name = 'payments.api.ch.gov.uk'),
           (SELECT id FROM journeys WHERE name = 'company-accounts')),
          ((SELECT id FROM nodes WHERE name = 'transactions.web.ch.gov.uk'),
           (SELECT id FROM nodes WHERE name = 'transactions.api.ch.gov.uk'),
           (SELECT id FROM journeys WHERE name = 'company-accounts')),
          ((SELECT id FROM nodes WHERE name = 'transactions.api.ch.gov.uk'),
           (SELECT id FROM nodes WHERE name = 'filing-resource-handler'),
           (SELECT id FROM journeys WHERE name = 'company-accounts')),
          ((SELECT id FROM nodes WHERE name = 'filing-resource-handler'),
           (SELECT id FROM nodes WHERE name = 'company-accounts.api.ch.gov.uk'),
           (SELECT id FROM journeys WHERE name = 'company-accounts')),
          ((SELECT id FROM nodes WHERE name = 'company-accounts.api.ch.gov.uk'),
           (SELECT id FROM nodes WHERE name = 'document-generator'),
           (SELECT id FROM journeys WHERE name = 'company-accounts')),
          ((SELECT id FROM nodes WHERE name = 'document-generator'),
           (SELECT id FROM nodes WHERE name = 'document-render-service'),
           (SELECT id FROM journeys WHERE name = 'company-accounts')),
          ((SELECT id FROM nodes WHERE name = 'document-render-service'),
           (SELECT id FROM nodes WHERE name = 'document-render-assets-registry'),
           (SELECT id FROM journeys WHERE name = 'company-accounts')),
          ((SELECT id FROM nodes WHERE name = 'filing-resource-handler'),
           (SELECT id FROM nodes WHERE name = 'chips-filing-consumer'),
           (SELECT id FROM journeys WHERE name = 'company-accounts')),
          ((SELECT id FROM nodes WHERE name = 'chips-filing-consumer'),
           (SELECT id FROM nodes WHERE name = 'chips'),
           (SELECT id FROM journeys WHERE name = 'company-accounts'));
    "
