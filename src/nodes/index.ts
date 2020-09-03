import express from 'express';
import {get} from './nodes';

const router = express.Router();

router.get('/', get);

export = router;
