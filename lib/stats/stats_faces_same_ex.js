var fs = require('fs'),
	path = require('path'),
	csv = require('ya-csv'),
	NDDB = require('NDDB').NDDB,
	J = require('JSUS').JSUS,
	d3 = require('d3'),
	prac = require('pra-core');

module.exports = {
	stats_faces_same_ex_all: stats_faces_same_ex_all,
	stats_faces_within_ex_subs: stats_faces_within_ex_subs,
	stats_faces_within_ex_pubs: stats_faces_within_ex_pubs,
	stats_faces_between_ex_subs: stats_faces_between_ex_subs
};
	
// LOADING DEFAULTS
//////////////////////

// CF FEATURES

var cf_features = prac.features;

var weightedFaceDistance = prac.dist.weightedFaceDistance;

var db = null;

var DIR = null;

function stats_faces_between_ex_subs(dir) {
	// Load DATA
	db = prac.db(dir, 'pr_full.nddb');
	DIR = dir;
	prac.writeRoundStatsByEx(dir, 'csv/diff/same_ex/diff_subs_ex_from_ex_by_ex', computeDiffSubmittedFacesBetweenExhibitions);
}

function stats_faces_within_ex_subs(dir) {
	// Load DATA
	db = prac.db(dir, 'pr_full.nddb');
	DIR = dir;
	prac.writeRoundStatsByEx(dir, 'csv/diff/same_ex/diff_subs_by_ex', computeDiffSubmittedFaces);
}

function stats_faces_within_ex_pubs(dir) {
	// Load DATA
	db = prac.db(dir, 'pr_full.nddb');
	DIR = dir;
	prac.writeRoundStatsByEx(dir, 'csv/diff/same_ex/diff_pubs_by_ex', computeDiffPublishedFaces);
}


function stats_faces_same_ex_all(dir) {
	
	stats_faces_between_ex_subs(dir);
	stats_faces_within_ex_subs(dir);
	stats_faces_within_ex_pubs(dir);
	
}


// First-order functions

function computeDiffSubmittedFaces(round, ex) {
	//console.log(round, ex);
	var faces = prac.getSubmittedFacesByEx(db, ex, round).fetch();
	return ('undefined' === typeof faces || !faces.length) ? 'NA' : prac.getAvgFaceDistance(faces);
}

function computeDiffPublishedFaces(round, ex) {
	var faces = prac.getPublishedFacesByEx(db, ex, round).fetch();
//		if ('undefined' === typeof faces || !faces.length || faces.length === 1) {
//			console.log('R ' + round + ' EX ' + ex);
//		}
	return ('undefined' === typeof faces || !faces.length || faces.length === 1) ? 'NA' : prac.getAvgFaceDistance(faces);
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
		other_faces = other_faces.concat(prac.getSubmittedFacesByEx(db, ex, round).fetch());
	});
	// faces in ex of reference
	faces = prac.getSubmittedFacesByEx(db, ex, round).fetch();
	
	if ('undefined' === typeof faces || !faces.length || faces.length === 1) return 'NA';
	if ('undefined' === typeof other_faces || !other_faces.length || other_faces.length === 1) return 'NA';
	
	return prac.getAvgFaceDistanceGroupFromGroup(faces, other_faces);
}