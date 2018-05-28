/* jshint esversion: 6 */
var bodyParser = require('body-parser');
const path = require('path');
let db = require('./db');
const express = require('express');
const app = express();
// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }));

// parse application/json
app.use(bodyParser.json());

app.use(function(req, res, next) {
	res.header('Access-Control-Allow-Origin', '*');
	res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
	next();
});
app.use(express.static('./assets'));

app.post('/api/slides', (req, res) => {
	let slides = req.body;
	db.postSlides(slides);
	res.json(db);
});

app.get('/api/slides', (req, res) => {
	const slides = db.getSlides();
	if (slides !== null) {
		res.json(slides);
	} else {
		res.status(404).send('Not Found');
	}
});

// app.get('/api/slide/:id', (req, res) => {
// 	const id = parseInt(req.params.id);
// 	const slide = db.getSlide(id);
// 	if (slide !== null) {
// 		res.json(slide);
// 	} else {
// 		res.status(404).send('Not Found');
// 	}
// });

app.get('/api/*', (req, res) => {
	res.status(404).send('Not Found');
});

app.get('*', (req, res) => {
	res.sendFile(path.join(__dirname, '../assets/index.html'));
});

const server = app.listen(4000, () => {
	const host = server.address().address;
	const port = server.address().port;
	console.log('Example app listening at http://%s:%s', host, port);
});
