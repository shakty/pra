var fs = require('fs'),
	path = require('path'),
	csv = require('ya-csv'),
	NDDB = require('NDDB').NDDB,
	J = require('./../../node_modules/NDDB/node_modules/JSUS/jsus.js').JSUS,
	d3 = require('d3'),
	pr_stats = require('./../../pr_stats');

module.exports = stats_reviews;

function stats_reviews(DIR, ACTION) {
	

	// Load DATA
	//var db = pr_stats.db(DIR, 'pr_full.nddb');
	var db = pr_stats.db(DIR, 'all_reviews.nddb');
	
	// LOADING DEFAULTS
	//////////////////////
	
	// PL
	var pl = pr_stats.pl(DIR);
	
	// HEADERS
	var pnames = pl.map(function(p){
		return "P_" + p.pc;
	});
	
	var rnames = pr_stats.rnames;
	
	// CF FEATURES
	
	var cf_features = pr_stats.features;
	
	var weightedFaceDistance = pr_stats.dist.weightedFaceDistance;
	
	////////////////////////////////////
	
	// HEADERS
	var pnames = pl.map(function(p){
		return "P_" + p.pc;
	});
	
	// HEADERS
	var pnames = []; 
	pl.each(function(p){
		var p = "P_" + p.pc + '_';
		pnames.push(p + 'score');
		pnames.push(p + 'in');
		pnames.push(p + 'out');
		pnames.push(p + 'same');
		pnames.push(p + 'inex');
		pnames.push(p + 'outex');
		pnames.push(p + 'sameex');
		pnames.push(p + 'changed');
	});
	
	var rnames_tmp = J.seq(1,30,1,function(e){
		if (e < 10) {
			e = '0' + e;
		}
		return 'R_' + e;
	});
	
	var rnames = [];
	J.each(rnames_tmp, function(p){
		rnames.push(p + '_score');
		rnames.push(p + '_in');
		rnames.push(p + '_out');
		rnames.push(p + '_same');
		pnames.push(p + 'inex');
		pnames.push(p + 'outex');
		pnames.push(p + 'sameex');
		pnames.push(p + 'changed');
	});
	
	
	if (ACTION === 'ROUND_STATS') {
		writeRoundStats(pl);
	}
	else if (ACTION === 'DISTANCE_VS_SCORE') {
		correlateDistanceFromOriginalAndScore();
	}
	
	
	
	function writeRoundStats(pl) {
		
		var pfile = 'ingroup/player_reviews.csv'; 					
		var rfile = 'ingroup/round_reviews.csv';
		
		// PLAYER STATS
		var pWriter = csv.createCsvStreamWriter(fs.createWriteStream(DIR + 'csv/' + pfile));
		pWriter.writeRecord(pnames);	
		var round = 1;
		while (round < 31) {
			var rev = 1;
			while (rev < 4) {
				// Divided by player
				var round_stuff = db.select('round','=',round)
										.select('rev', '=', rev).sort('pc');
				
				var reviews = [];
				round_stuff.each(function(p){
					console.log(pl.id[p.player].first().pc);
					reviews.push(p.score);
					reviews.push(p.incolor);
					reviews.push(p.outcolor);
					reviews.push(p.samecolor);
					reviews.push(p.inex);
					reviews.push(p.outex);
					reviews.push(p.sameex);
					reviews.push(p.hasChanged);
					
				});
				pWriter.writeRecord(reviews);
				//console.log(subs);
				rev++;
			}
			
			round++;
		}
		console.log("wrote " + pfile);
	
		// ROUND STATS
		var rWriter = csv.createCsvStreamWriter(fs.createWriteStream(DIR + 'csv/' + rfile));
		rWriter.writeRecord(rnames);
	
		for (var pl in db.player) {
			
			if (db.player.hasOwnProperty(pl)) {
				
				db.player[pl].sort('round');
				var reviews = db.player[pl].map(function(p) {
					return [p.score, p.incolor, p.outcolor, p.samecolor, p.inex, p.outex, p.sameex, p.hasChanged];
				});
				rWriter.writeRecord(reviews);
				
			}
		}
		console.log("wrote " + rfile);	
	}
	
	
	
	function correlateDistanceFromOriginalAndScore() {
		
		var round = 2; // IMPORTANT 2
		var old_faces, faces, round_stuff;
		
		var file = DIR + 'csv/diff/diffandscore/copy_from_original_andscore.csv';
		
		var writer = csv.createCsvStreamWriter(fs.createWriteStream(file));
		writer.writeRecord(['D','S']);	
		
	
		var ldb = db.select('copy');
		
		
		var score, distance;
		var faces = ldb.each(function(p) {
			var orig = db.select('player.id', '=', p.copy.copied_from.id)
			.select('state.round', '=',  p.copy.copied_round).first();
			
			distance = weightedFaceDistance(orig.value, p.value);
			score = p.avg;
			writer.writeRecord([distance, score]);
		});
		
		console.log("wrote " + file);
	
	}
		
	var avgDiffCopy = db.map(function(e){
		if (!e.copy) return;
		
		var orig = db.select('player.id', '=', e.copy.copied_from.id)
						.select('state.round', '=',  e.copy.copied_round).first();
		
		return weightedFaceDistance(orig.value, e.value);
	});
	
	
	var avgDiffCopyWriter = csv.createCsvStreamWriter(fs.createWriteStream(DIR + 'csv/copy/copy_diffs.csv'));
	avgDiffCopyWriter.writeRecord(['DIFFS']);
	J.each(avgDiffCopy, function(e){
		avgDiffCopyWriter.writeRecord([e]);
	});
}

