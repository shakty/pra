var fs = require('fs'),
	path = require('path'),
	csv = require('ya-csv'),
	NDDB = require('NDDB').NDDB,
	d3 = require('d3');


var create_html_by_player = require('./create_html_copy').create_html_by_player,
	create_html_copies_only = require('./create_html_copy').create_html_copies_only,
	create_html_by_ex = require('./create_html_exh'),
	create_html_stats = require('./create_html_stats_pages');

function create_html_all(DIR) {

	create_html_by_player(DIR, function() {
		
		create_html_copies_only(DIR, function(){
			
			// only published
			create_html_by_ex(DIR, true, function() {
				// all submissions
				create_html_by_ex(DIR, false, function() {
					// All the other stats
					create_html_stats.create_html_stats_all(DIR);
				}); 
			});
		});
		
	});	
}

function create_html_by_player(DIR, cb) {
	create_html(DIR, cb); // creates also the copies index
}

function create_html_by_ex_pub(DIR, cb) {
	create_html_by_ex(DIR, true, cb);
}

function create_html_by_ex_all(DIR, cb) {
	create_html_by_ex(DIR, false, cb);
}

module.exports = {
		create_html_all: create_html_all,
		create_html_by_ex_pub: create_html_by_ex_pub,
		create_html_by_ex_all: create_html_by_ex_all,
		create_html_by_player: create_html_by_player,
		create_html_copies_only: create_html_copies_only,
		create_html_stats: create_html_stats
};


