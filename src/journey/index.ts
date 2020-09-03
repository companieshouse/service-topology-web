import express from 'express';
import {get} from './journey';

const router = express.Router();

router.get('/', get);

export = router;
