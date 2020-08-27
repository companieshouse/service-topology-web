import {Request, Response} from 'express';
import { RDSDatabase } from "rds-data";

import config from '../config';
import logger from '../logger';

const params = {
    region: config.db.region,
    secretArn: config.db.secret_arn,
    resourceArn: config.db.resource_arn,
    database: config.db.name
};

export async function get(req: Request, res: Response): Promise<Response> {

    const db = new RDSDatabase(params).getInstance();
    const results = await db.query( "SELECT name FROM journeys" );

    let journeyNames:String[] = [];

    results.data.forEach(journey => {
      journeyNames.push(String(journey.name.string));
    })

    return res.send(journeyNames);
}
