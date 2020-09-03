import express from 'express';
import {get} from './network';

const router = express.Router();

router.get('/', get);

export = router;
