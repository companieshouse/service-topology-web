import express from 'express';
import {get} from './edges';

const router = express.Router();

router.get('/', get);

export = router;
