import express from 'express';
import {get} from './home';

const router = express.Router();

router.get('/', get);

export = router;
