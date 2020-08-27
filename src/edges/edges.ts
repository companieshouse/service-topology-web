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

export class Edge {
  source: number;
  target: number;
  journey: number;

  constructor(source: number, target: number, journey: number) {
    this.source = source;
    this.target = target;
    this.journey = journey;
  }
}

export async function get(req: Request, res: Response): Promise<Response> {

    //const journey = req.query.journey;

    return res.send('ok!');
}

export async function GetEdges(journey: string): Promise<Edge[]> {

    let query = "SELECT * FROM edges";
    if (journey != 'all') {
      query += " INNER JOIN journeys " +
      "ON edges.journey_id = journeys.id " +
      "WHERE journeys.name = '" + journey + "'";
    }

    const db = new RDSDatabase(params).getInstance();
    const results = await db.query(query);

    let edges:Edge[] = [];
    results.data.forEach((edge) => {
      edges.push(new Edge(<number> edge.source.number, <number> edge.target.number, <number> edge.journey_id.number));
    });

    return edges;
}
