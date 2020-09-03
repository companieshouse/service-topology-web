import {Request, Response} from 'express';
import { GetEdges } from '../edges/edges';
import { GetNodes } from '../nodes/nodes';

import logger from '../logger';

export async function get(req: Request, res: Response): Promise<Response> {

    const journey = <string> req.query.journey;

    const edges = await GetEdges(journey);

    let linkedApps:number[] = [];
    edges.forEach((edge) => {
      if (!linkedApps.includes(edge.source)) {
        linkedApps.push(edge.source);
      }
      if (!linkedApps.includes(edge.target)) {
        linkedApps.push(edge.target);
      }
    });

    const nodes = await GetNodes(linkedApps);

    return res.send({
      nodes,
      links: edges
    });
}
