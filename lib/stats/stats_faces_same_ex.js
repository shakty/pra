var fs = require('fs'),
	path = require('path'),
	csv = require('ya-csv'),
	NDDB = require('NDDB').NDDB,
	J = require('./../../node_modules/NDDB/node_modules/JSUS/jsus.js').JSUS,
	d3 = require('d3'),
	pr_stats = require('./../../pr_stats');

module.exports = {
	stats_faces_same_ex_all: stats_faces_same_ex_all,
	stats_faces_within_ex_subs: stats_faces_within_ex_subs,
	stats_faces_within_ex_pubs: stats_faces_within_ex_pubs,
	stats_faces_between_ex_subs: stats_faces_between_ex_subs
};
	
// LOADING DEFAULTS
//////////////////////

// CF FEATURES

var cf_features = pr_stats.features;

var weightedFaceDistance = pr_stats.dist.weightedFaceDistance;

var exs = ['A','B','C'];

var db = null;

var DIR = null;

function stats_faces_between_ex_subs(dir) {
	// Load DATA
	db = pr_stats.db(dir, 'pr_full.nddb');
	DIR = dir;
	writeRoundStatsByEx('csv/diff/same_ex/diff_subs_ex_from_ex_by_ex', computeDiffSubmittedFacesBetweenExhibitions);
}

function stats_faces_within_ex_subs(dir) {
	// Load DATA
	db = pr_stats.db(dir, 'pr_full.nddb');
	DIR = dir;
	writeRoundStatsByEx('csv/diff/same_ex/diff_subs_by_ex', computeDiffSubmittedFaces);
}

function stats_faces_within_ex_pubs(dir) {
	// Load DATA
	db = pr_stats.db(dir, 'pr_full.nddb');
	DIR = dir;
	writeRoundStatsByEx('csv/diff/same_ex/diff_pubs_by_ex', computeDiffPublishedFaces);
}


function stats_faces_same_ex_all(dir) {
	
	stats_faces_between_ex_subs(dir);
	stats_faces_within_ex_subs(dir);
	stats_faces_within_ex_pubs(dir);
	
}


// First-order functions

function computeDiffSubmittedFaces(round, ex) {
	//console.log(round, ex);
	var faces = getSubmittedFacesByEx(ex, round).fetch();
	return ('undefined' === typeof faces || !faces.length) ? 'NA' : getAvgFaceDistance(faces);
}

function computeDiffPublishedFaces(round, ex) {
	var faces = getPublishedFacesByEx(ex, round).fetch();
//		if ('undefined' === typeof faces || !faces.length || faces.length === 1) {
//			console.log('R ' + round + ' EX ' + ex);
//		}
	return ('undefined' === typeof faces || !faces.length || faces.length === 1) ? 'NA' : getAvgFaceDistance(faces);
}

function computeDiffSubmittedFacesBetweenExhibitions(round, ex) {
	var set, faces, other_faces = [];
	if (ex === 'A') { 
		set = ['B','C']; 
	}
	else if (ex === 'B') {
		set = ['A','C'];
	}
	else {
		set = ['B','A'];
	}
	// faces submitted to other exhibitions
	J.each(set, function(ex) {
		other_faces = other_faces.concat(getSubmittedFacesByEx(ex, round).fetch());
	});
	// faces in ex of reference
	faces = getSubmittedFacesByEx(ex, round).fetch();
	
	if ('undefined' === typeof faces || !faces.length || faces.length === 1) return 'NA';
	if ('undefined' === typeof other_faces || !other_faces.length || other_faces.length === 1) return 'NA';
	
	return getAvgFaceDistanceGroupFromGroup(faces, other_faces);
}
	
	
/// Support functions

function getPublishedFaces(round, cumulative) {
	if (!round) return false;
	cumulative = cumulative || false;
	
	var s = (cumulative) ? db.select('state.round', '<=', round)
						 : db.select('state.round', '=', round);
	
//		console.log('CUMULATIVE ' + cumulative);
//		console.log(s.length)
	
	return s.select('published', '=', true);
}

function getSubmittedFacesByEx(ex, round, cumulative) {
	if (!round) return false;
	cumulative = cumulative || false;
	
	var exdb = db.select('ex','=', ex);
	
	return (cumulative) ? exdb.select('state.round', '<=', round)
						 : exdb.select('state.round', '=', round);
	
//		console.log('CUMULATIVE ' + cumulative);
//		console.log(s.length)
	
}

function getPublishedFacesByEx(ex, round, cumulative) {
	if (!round) return false;
	cumulative = cumulative || false;
	
	var exdb = db.select('ex','=', ex);
	
	var s = (cumulative) ? exdb.select('state.round', '<=', round)
						 : exdb.select('state.round', '=', round);
	
//		console.log('CUMULATIVE ' + cumulative);
//		console.log(s.length)
	
	return s.select('published', '=', true);
	
}

function getAvgDistanceFromPubFaces(face, round, cumulative) {
	if (!face || !round) return false;
	var pubs = getPublishedFaces(round, cumulative);
	
	// TODO: check this
	// If there are no pubs in the previous round diff = 1
	if (!pubs || !pubs.length) return 'NA';

	var diffs = 0; 
	
	pubs.each(function(e){
		diffs += weightedFaceDistance(face, e.value);
	});
	
	return diffs / pubs.length;
}

function getAvgFaceDistance(faces) {
	if (!faces || !faces.length || faces.length === 1) return 'NA';
	var copy, face, faceDiff = 0;
	for (var i = 0 ; i < faces.length ; i++) {
		copy = faces.slice(0);
		copy.splice(i,1);
		face = faces[i];
		
		faceDiff+= getAvgFaceDistanceFromGroup(face, copy);	
		
	}
	return faceDiff / faces.length;
}

// must take care of not including the face in the group
function getAvgFaceDistanceFromGroup(face, group) {
	var diffs = 0;
//		console.log(face);
//		console.log(group.length)
	J.each(group, function(e){
		diffs += weightedFaceDistance(face.value, e.value);
	});
	return diffs / group.length;
}

function getAvgFaceDistanceGroupFromGroup(group1, group2) {
	var diffs = 0;
	
	J.each(group1, function(face){
		diffs += getAvgFaceDistanceFromGroup(face, group2);
	});
	
	return diffs / group1.length;
}


function writeRoundStatsByEx(outfile, func) {
	
	var file = DIR + outfile + '.csv';
	var pWriter = csv.createCsvStreamWriter(fs.createWriteStream(file));
	pWriter.writeRecord(exs);	

	var faces, faceDiff, round = 1;
	while (round < 31) {
		faceDiff = J.map(exs, function(ex) {
			return func(round, ex);
		});
		pWriter.writeRecord(faceDiff);	
		round++;
	}
	
	console.log("wrote " + file);

}

function writePreviousRoundStats() {
	
	var round = 2; // IMPORTANT 2
	var old_faces, faces, round_stuff;
	
	var file = DIR + 'csv/diff/previouspub/diff_pubs_players_previous.csv';
	
	var writer = csv.createCsvStreamWriter(fs.createWriteStream(file));
	writer.writeRecord(pnames);	
	
	while (round < 31) {


		
		// Divided by player
		round_stuff = db.select('state.round', '=', round).sort('player');

		//for (var R = 1; R < round; R++) {
			faces = round_stuff.map(function(p) {
				return getAvgDistanceFromPubFaces(p.value, (round-1));		
			});
			
			
			writer.writeRecord(faces);
			console.log(faces);
		//}
		

		round++;
	}
	console.log("wrote " + file);

}

function writeCumulativeRoundStats() {
	
	var round = 2; // IMPORTANT 2
	var old_faces, faces, round_stuff;
	
	var file = DIR + 'csv/diff/previouspub/diff_pubs_players_cumulative.csv';
	
	var writer = csv.createCsvStreamWriter(fs.createWriteStream(file));
	writer.writeRecord(pnames);	
	
	while (round < 31) {

		// Divided by player
		round_stuff = db.select('state.round', '=', round).sort('player');

		faces = round_stuff.map(function(p) {
			faceDiff = getAvgDistanceFromPubFaces(p.value, (round-1), true);
			if (!p.diff) p.diff = {};
			p.diff.pubsCum = faceDiff;	
			return faceDiff;
		});
		
		
		writer.writeRecord(faces);
		//console.log(faces);
		

		round++;
	}
	console.log("wrote " + file);

}

function correlateDistanceFromOriginalAndScore() {
	
	var round = 2; // IMPORTANT 2
	var old_faces, faces, round_stuff;
	
	var file = DIR + 'csv/diff/diffandscore/diffandscore.csv';
	
	var writer = csv.createCsvStreamWriter(fs.createWriteStream(file));
	writer.writeRecord(['D','S']);	
	
	while (round < 31) {

		// Divided by player
		round_stuff = db.select('state.round', '=', round).sort('player');

		var score, distance;
		faces = round_stuff.each(function(p) {
			distance = getAvgDistanceFromPubFaces(p.value, (round-1));
			score = p.avg;
			writer.writeRecord([distance, score]);
		});
		round++;
	}
	console.log("wrote " + file);

}

function correlateDistanceAndScore() {
	
	var round = 2; // IMPORTANT 2
	var old_faces, faces, round_stuff;
	
	var file = DIR + 'csv/diff/diffandscore/diffandscore.csv';
	
	var writer = csv.createCsvStreamWriter(fs.createWriteStream(file));
	writer.writeRecord(['D','S']);	
	
	while (round < 31) {

		// Divided by player
		round_stuff = db.select('state.round', '=', round).sort('player');

		var score, distance;
		faces = round_stuff.each(function(p) {
			distance = getAvgDistanceFromPubFaces(p.value, (round-1));
			score = p.avg;
			writer.writeRecord([distance, score]);
		});
		round++;
	}
	console.log("wrote " + file);

}

function correlateDistanceAndScoreCopy() {
	
	var round = 2; // IMPORTANT 2
	var old_faces, faces, round_stuff;
	
	var file = DIR + 'csv/diff/diffandscore/diffandscore_copy.csv';
	
	var writer = csv.createCsvStreamWriter(fs.createWriteStream(file));
	writer.writeRecord(['D','S']);	
	
	while (round < 31) {

		// Divided by player
		round_stuff = db.select('state.round', '=', round).sort('player');

		var score, distance;
		faces = round_stuff.each(function(p) {
			if (!p.copy) return;
			distance = getAvgDistanceFromPubFaces(p.value, (round-1));
			score = p.avg;
			writer.writeRecord([distance, score]);
		});
		round++;
	}
	console.log("wrote " + file);

}