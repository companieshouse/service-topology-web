import express from 'express';
import {get} from './graph';

const router = express.Router();

router.get('/', get);

export = router;
