var fs = require('fs'),
	path = require('path'),
	csv = require('ya-csv'),
	NDDB = require('NDDB').NDDB,
	J = require('JSUS').JSUS,
	d3 = require('d3'),
	pr_stats = require('./../../pr_stats');


module.exports = stats_copy;

function stats_copy(DIR, ACTION, cb) {
	
	
	var db = pr_stats.db(DIR, 'all_cf_sub_eva_copy.nddb');
	
	// LOADING DEFAULTS
	//////////////////////
	
	// PL
	var pl = pr_stats.pl(DIR);
	
	// HEADERS
	var header = pl.map(function(p){
		return "P_" + p.pc;
	});
	
	header = ['round', 'player'].concat(header);

	
	////////////////////////////////////

	
	// HEADERS
	var pnames = pl.map(function(p){
		return "P_" + p.pc;
	});
	
	var rnames = pr_stats.rnames; 
	
	var cf_features = pr_stats.features;

	var weightedFaceDistance = pr_stats.dist.weightedFaceDistance;
	
	
	
	
	if (ACTION === 'ROUND_STATS') {
		writeRoundStats();
	}
	else if (ACTION === 'ROUND_STATS_NORM') {
		writeRoundStats(true);
	}
	else if (ACTION === 'DISTANCE_VS_SCORE') {
		correlateDistanceFromOriginalAndScore();
	}
	
	
	function writeRoundStats(normalize) {
		
		var pfile = (normalize) ? 'copy/copy_x_round_x_player_norm.csv'
								: 'copy/copy_x_round_x_player.csv'; 
						
		var rfile = 'copy/copy_x_round.csv';
		
	//	var efile = 'copy/sub_x_ex_round.csv';
	//	
	//	var prfile = 'sub_x_player_x_round.csv';
		
		// PLAYER STATS
		var pWriter = csv.createCsvStreamWriter(fs.createWriteStream(DIR + 'csv/' + pfile));
		pWriter.writeRecord(pnames);	
		var round = 1;
		while (round < 31) {
			
			// Divided by player
			var round_stuff = db.select('state.round','=',round).sort('player');
			var copies = round_stuff.map(function(p){
				if (p.copy) {
					return (normalize) ? (p.state.round - p.copy.copied_round) / (p.state.round - 1)
							   		   : p.state.round - p.copy.copied_round;
				}
				else {
					return 0;
				}
			});
			pWriter.writeRecord(copies);
			//console.log(subs);
			round++;
		}
		console.log("wrote " + pfile);
	
		// ROUND STATS
		var rWriter = csv.createCsvStreamWriter(fs.createWriteStream(DIR + 'csv/' + rfile));
		rWriter.writeRecord(rnames);
	
		for (var pl in db.player) {
			if (db.player.hasOwnProperty(pl)) {
				
				db.player[pl].sort('round');
				var copies_pl = db.player[pl].map(function(p) {
					if (p.copy) {
						return p.state.round - p.copy.copied_round;
					}
					else {
						return 0;
					}
				});
				rWriter.writeRecord(copies_pl);
				
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
