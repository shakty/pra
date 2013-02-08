var fs = require('fs'),
	path = require('path'),
	csv = require('ya-csv'),
	NDDB = require('NDDB').NDDB,
	J = require('JSUS').JSUS,
	d3 = require('d3'),
	pra = require('pra-core');


var file, DIR, path2file;;

if (process.argv || process.argv.length) {
	// 0 = node, 1 ex.js
	path2file = path.normalize(process.argv[2]);
	DIR = path.dirname(path2file) + '/';
	file = path.basename(path2file);
}

if (!file || !DIR) {
	console.log('You must specify a file to repair.');
	return;
}

pra.repair(DIR, file);