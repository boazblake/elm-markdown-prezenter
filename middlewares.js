let db = require('./dbs/semantics/db.json');

let counter = 0;
const id = () => counter + 1;

module.exports = (req, res, next) => {
	console.log('slides', db);
	console.log('id', id);
	console.log(req.body);

	switch (req.method) {
		case 'POST':
			db.slides[id()] = req.body;
			console.log('POSTING SLIDES>git stta>>>>>>>\n', db.slides[id()]);
			next();
			break;
		case 'GET':
			console.log('FETCHING SLIDES>>>>\n', db.slides);
			next();
			break;
		default:
			console.log('error', req.method);
			next();
			break;
	}
};
