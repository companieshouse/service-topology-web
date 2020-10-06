# service-topology-web

## Environment Variables

Required Environment Variables:

``APP_PORT`` -- *The port to run the application on*
``DB_REGION`` -- *The AWS region for the DB*
``DB_RESOURCE_ARN`` -- *AWS ARN for the DB*
``DB_SECRET_ARN`` -- *AWS ARN secret for the DB*
``DB_NAME`` -- *DB name for the service*
``NODE_ENV`` -- *Node environment in which the app is running*


NB: This project uses the [dotenv](https://github.com/motdotla/dotenv#readme) library for local development. You can create a ``.env`` file in the root of the project containing the above environment variables to get up and running.