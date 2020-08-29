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

export class Node {
  id: number;
  name: string;
  colour: string;

  constructor(id: number, name: string, colour: string) {
    this.id = id;
    this.name = name;
    this.colour = colour;
  }
}

export async function get(req: Request, res: Response): Promise<Response> {

    //const journey = req.query.journey;

    return res.send('ok!');
}

export async function GetNodes(linkedApps: number[]): Promise<Node[]> {

    let query = "SELECT id, name, colour FROM nodes WHERE id IN (" + linkedApps.toString() + ")"

    const db = new RDSDatabase(params).getInstance();
    const results = await db.query(query);

    let nodes:Node[] = [];
    results.data.forEach((node) => {
      nodes.push(new Node(<number> node.id.number, <string> node.name.string, <string> node.colour.string));
    });

    return nodes;
}
