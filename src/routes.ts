import express from 'express';

import home from './home';
import graph from './graph';
import network from './network';
import journey from './journey';

const router = express.Router();

router.use('/', home);
router.use('/graph', graph);
router.use('/network', network);
router.use('/journeys', journey);

export = router;
