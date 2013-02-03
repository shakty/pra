var stats = require('./lib/stats/stats_all');

var DIR = undefined;

if (process.argv || process.argv.length) {
	// 0 = node, 1 ex.js
	DIR = process.argv[2];
}

if (!DIR) {
	DIR = './data/com_choice_31_jan_2013/';
}

///////////////////////


stats.stats_all(DIR);
