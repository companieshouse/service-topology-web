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
  threejs_geometry: string;
  threejs_geometry_attributes: string;
  threejs_material: string;
  threejs_material_attributes: string;

  constructor(id: number, name: string, threejs_geometry: string, threejs_geometry_attributes: string, threejs_material: string, threejs_material_attributes: string) {
    this.id = id;
    this.name = name;
    this.threejs_geometry = threejs_geometry;
    this.threejs_geometry_attributes = threejs_geometry_attributes;
    this.threejs_material = threejs_material;
    this.threejs_material_attributes = threejs_material_attributes;
  }
}

export async function get(req: Request, res: Response): Promise<Response> {

    //const journey = req.query.journey;

    return res.send('ok!');
}

export async function GetNodes(linkedApps: number[]): Promise<Node[]> {

    let query = "SELECT nodes.id, nodes.name, threejs_geometry, threejs_geometry_attributes, threejs_material, threejs_material_attributes FROM service_topology.nodes INNER JOIN service_topology.node_types ON nodes.node_type_id = node_types.id  WHERE nodes.id IN (" + linkedApps.toString() + ")"

    const db = new RDSDatabase(params).getInstance();
    const results = await db.query(query);

    let nodes:Node[] = [];
    results.data.forEach((node) => {
      nodes.push(new Node(<number> node.id.number, <string> node.name.string, <string> node.threejs_geometry.string, <string> node.threejs_geometry_attributes.string, <string> node.threejs_material.string, <string> node.threejs_material_attributes.string ));
    });

    return nodes;
}
