const config = {
    app: {
        port: (process.env.APP_PORT as string)
    },
    db: {
        region: (process.env.DB_REGION as string),
        resource_arn: (process.env.DB_RESOURCE_ARN as string),
        secret_arn: (process.env.DB_SECRET_ARN as string),
        name: (process.env.DB_NAME as string)
    },
    env: (process.env.NODE_ENV as string)
};

export default config;
