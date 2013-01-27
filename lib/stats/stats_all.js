var fs = require('fs'),
	path = require('path'),
	csv = require('ya-csv'),
	NDDB = require('NDDB').NDDB,
	J = require('./../../../node_modules/NDDB/node_modules/JSUS/jsus.js').JSUS,
	d3 = require('d3'),
	pr_stats = require('./../../../pr_stats');


var stats_copy =  require('./stats_copy'),
	stats_faces_pub =  require('./stats_faces_pub'),
	stats_faces_self =  require('./stats_faces_self'),
	stats_faces =  require('./stats_faces'),
	stats_ingroup =  require('./stats_ingroup'),
	stats_players =  require('./stats_players'),
	stats_pubs =  require('./stats_pubs'),
	stats_reviews =  require('./stats_reviews'),
	stats_subs =  require('./stats_subs'),
	stats_win_lose =  require('./stats_win_lose');


function stats_all(DIR) {

	stats_faces_all(DIR);

	stats_ingroup(DIR);
	
	stats_players(DIR);
	
	stats_pubs(DIR);
	
	stats_reviews_all(DIR);

	stats_subs_all(DIR);
	
	stats_win_lose(DIR);
	
	// COPIES
	stats_copy_all();
	
}

// COPIES
function stats_copy_all(DIR) {
	stats_copy(DIR, 'ROUND_STATS');
	stats_copy(DIR, 'ROUND_STATS_NORM');
	stats_copy(DIR, 'DISTANCE_VS_SCORE');
}

function stats_copy_round(DIR) {
	stats_copy(DIR, 'ROUND_STATS');
}

function stats_copy_round_norm(DIR) {
	stats_copy(DIR, 'ROUND_STATS_NORM');
}

function stats_copy_round_distance_and_score(DIR) {
	stats_copy(DIR, 'DISTANCE_VS_SCORE');
}

// FACES
function stats_faces_all(DIR) {
	stats_faces_pub(DIR);
	stats_faces_self(DIR);
	stats_faces(DIR);
}

// REVIEWS
function stats_reviews_all(DIR) {
	stats_reviews(DIR, 'ROUND_STATS');
	stats_reviews(DIR, 'DISTANCE_VS_SCORE');
}

function stats_reviews_round(DIR) {
	stats_reviews(DIR, 'ROUND_STATS');
}

function stats_reviews_distance_and_score(DIR) {
	stats_reviews(DIR, 'DISTANCE_VS_SCORE');
}

// SUBS
function stats_subs_all(DIR) {
	stats_subs(DIR);
	stats_subs(DIR, 'TRANSFORM');
}

function stats_subs_letters(DIR) {
	stats_subs(DIR);
}

function stats_subs_integers(DIR) {
	stats_subs(DIR, 'TRANSFORM');
}

module.exports = {
	stats_all: stats_all,
	
	// COPIES
	stats_copy_all: stats_copy_all,
	stats_copy_round: stats_copy_round,
	stats_copy_round_norm: stats_copy_round_norm,
	stats_copy_round_distance_and_score: stats_copy_round_distance_and_score,
	
	// FACES
	stats_faces_all: stats_faces_all,
	stats_faces_pub: stats_faces_pub,
	stats_faces_self: stats_faces_self,
	stats_faces: stats_faces,
	
	stats_ingroup: stats_ingroup,
	
	stats_players: stats_players,
	
	stats_pubs: stats_pubs,
	
	// REVIEWS
	stats_reviews_all: stats_reviews_all,
	stats_reviews_round: stats_reviews_round,
	stats_reviews_distance_and_score: stats_reviews_distance_and_score,
	
	// SUBS
	stats_subs_all: stats_subs_all,
	stats_subs_letters: stats_subs_letters,
	stats_subs_integers: stats_subs_integers,
	
	stats_win_lose: stats_win_lose,
};


