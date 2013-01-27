var fs = require('fs'),
	path = require('path'),
	csv = require('ya-csv'),
	NDDB = require('NDDB').NDDB,
	J = require('./../../../node_modules/NDDB/node_modules/JSUS/jsus.js').JSUS,
	d3 = require('d3');


var load_faces = require('./load_faces'),
	load_reviews = require('./load_reviews'),
	load_evas = require('./load_eva'),
	load_subs = require('./load_sub'),
	load_copies = require('./load_copy'),
	print_faces = require('./print_faces');


function load_all(dir, print) {
	
	print = print || false;
	
	load_faces(dir, function() {
		load_subs(dir, function() {
			load_evas(dir, function() {
				load_copies(dir, function() {
					// in-group
					load_reviews(dir, function() {
						// print faces
						if (print) {
							print_faces(dir);
						}
					});
				});
			});
		});
	});
}

//load_all();

module.exports = {
		load_all: load_all,
		load_reviews: load_reviews,
		load_evas: load_evas,
		load_subs: load_subs,
		load_copies: load_copies,
		print_faces: print_faces
};