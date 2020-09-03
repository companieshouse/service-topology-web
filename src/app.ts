import bodyParser from 'body-parser';
import express from 'express';
import flash from 'connect-flash';
import path from 'path';
import validator from 'express-validator';

import config from './config';
import routes from './routes';

const app = express();
const port = config.app.port;

app.set('view engine', 'pug');
app.set('views', path.join(__dirname, '/views'));

app.use(bodyParser.urlencoded({
    extended: true
}));

app.use(bodyParser.json());

app.use(validator());

app.use(express.static(path.join(__dirname + '/public')));

app.use(flash());

app.use('/', routes);

app.listen(port, () => {
    console.log('Listening on port ' + port);
});
