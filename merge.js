var fs = require('fs'),
	path = require('path'),
	csv = require('ya-csv'),
	NDDB = require('NDDB').NDDB,
	J = require('JSUS').JSUS,
	d3 = require('d3'),
	pra = require('pra-core');

var times = fs.readFileSync('./data/times.js', 'utf-8');
	times = JSON.parse(times);

var featnames = pra.featnames.all;

var sessions = {
             // 25 JAN 2013
             'com_rand_25_jan_2013': {
            	 date: '25-01-2013',
            	 after: 0,
            	 morn: 1,
            	 id: 1,
            	 serverdir: '25Jan2013/games/com_rand_1/server/out/'
             },
             'com_choice_25_jan_2013': {
        	 	date: '25-01-2013',
        	 	after: 1,
        	 	morn: 0,
        	 	id: 2,
        	 	serverdir: '25Jan2013/games/PR4/server/out/'
        	 },
             // 30 JAN 2013
             'coo_rand_30_jan_2013': {
            	 date: '30-01-2013',
            	 after: 0,
            	 morn: 1,
         	 	 id: 3,
         	 	 serverdir: '30Jan2013/games/coo_rand/server/out/'
             },
             'coo_choice_30_jan_2013': {
            	 date: '30-01-2013',
            	 after: 1,
            	 morn: 0,
         	 	 id: 4,
         	 	 serverdir: '30Jan2013/games/coo_choice/server/out/'
             },
             // 31 JAN 2013
             'com_choice_31_jan_2013': {
            	 date: '31-01-2013',
            	 after: 0,
            	 morn: 1,
         	 	 id: 5,
         	 	 serverdir: '31Jan2013/games/com_choice/server/out/'
             },
             'coo_rand_31_jan_2013': {
            	 date: '31-01-2013',
            	 after: 1,
            	 morn: 0,
         	 	 id: 6,
         	 	 serverdir: '31Jan2013/games/coo_rand/server/out/'
             },
             // 1 FEB 2013
             'com_rand_1_feb_2013': {
            	 date: '01-02-2013',
            	 after: 1,
            	 morn: 0,
         	 	 id: 7,
         	 	 serverdir: '1Feb2013/games/com_rand/server/out/'
             },
             'coo_choice_1_feb_2013': {
            	 date: '01-02-2013',
            	 after: 0,
            	 morn: 1,
         	 	 id: 8,
         	 	 serverdir: '1Feb2013/games/coo_choice/server/out/'
             },
             // 4 FEB 2013
             'com_rand_4_feb_2013': {
            	 date: '04-02-2013',
            	 after: 1,
            	 morn: 0,
         	 	 id: 9,
         	 	 serverdir: '4Feb2013/games/com_rand/server/out/'
             },
             'coo_rand_4_feb_2013': {
            	 date: '04-02-2013',
            	 after: 0,
            	 morn: 1,
         	 	 id: 10,
         	 	 serverdir: '4Feb2013/games/coo_rand/server/out/'
             },
             // 6 FEB 2013
             'coo_choice_6_feb_2013': {
            	 date: '06-02-2013',
            	 after: 0,
            	 morn: 1,
         	 	 id: 11,
         	 	 serverdir: '6Feb2013/games/coo_choice/server/out/'
             },
             'com_choice_6_feb_2013': {
            	 date: '06-02-2013',
            	 after: 1,
            	 morn: 0,
         	 	 id: 12,
         	 	serverdir: '6Feb2013/games/com_choice/server/out/'
             },
             // 7 FEB 2013
             'com_rand_7_feb_2013': {
            	 date: '07-02-2013',
            	 after: 0,
            	 morn: 1,
         	 	 id: 13,
         	 	 serverdir: '7Feb2013/games/com_rand/server/out/'
             },
             'coo_rand_7_feb_2013': {
            	 date: '07-02-2013',
            	 after: 1,
            	 morn: 0,
         	 	 id: 14,
         	 	 serverdir: '7Feb2013/games/coo_rand/server/out/'
            	 
             },
             // 8 FEB 2013
             'com_choice_8_feb_2013': {
            	 date: '08-02-2013',
            	 after: 0,
            	 morn: 1,
         	 	 id: 15,
         	 	 serverdir: '8Feb2013/games/com_choice/server/out/'
             },
             'coo_choice_8_feb_2013': {
            	 date: '08-02-2013',
            	 after: 1,
            	 morn: 0,
         	 	 id: 16,
         	 	 serverdir: '1Feb2013/games/coo_choice/server/out/'
             }
};




var headings = [
                // session
                'session',
                'date',
                'morning',
                'afternoon',
                
                // treatments
                'com',
                'coo',
                'choice',
                'rand',
                
                // player
                'p.id',
                'p.number',
                'p.color',
                
                // round
                'round',
                
                // features
                'f.head_radius',
                'f.head_scale_x',
                'f.head_scale_y',
                'f.eye_height',
                'f.eye_spacing',
                'f.eye_scale_x',
                'f.eye_scale_y',
                'f.eyebrow_length',
                'f.eyebrow_eyedistance',
                'f.eyebrow_angle',
                'f.eyebrow_spacing',
                'f.mouth_top_y',
                'f.mouth_bottom_y',
                
                // features
                'f.norm.head_radius',
                'f.norm.head_scale_x',
                'f.norm.head_scale_y',
                'f.norm.eye_height',
                'f.norm.eye_spacing',
                'f.norm.eye_scale_x',
                'f.norm.eye_scale_y',
                'f.norm.eyebrow_length',
                'f.norm.eyebrow_eyedistance',
                'f.norm.eyebrow_angle',
                'f.norm.eyebrow_spacing',
                'f.norm.mouth_top_y',
                'f.norm.mouth_bottom_y',
                
                // ex
                'ex',
                'published',
                
                // reviews (received)
                'r1',
                'r1.id',
                'r1.color',
                'r1.ex',
                'r1.same.color',
                'r1.same.ex',
                'r1.changed',
                'r2',
                'r2.id',
                'r2.color',
                'r2.ex',
                'r2.same.color',
                'r2.same.ex',
                'r2.changed',
                'r3',
                'r3.id',
                'r3.color',
                'r3.ex',
                'r3.same.color',
                'r3.same.ex',
                'r3.changed',
                'r.mean',
                'r.std',
                
                // evaluations (done)
                'e1',
                'e1.id',
                'e1.color',
                'e1.ex',
                'e1.same.color',
                'e1.same.ex',
                'e2',
                'e2.id',
                'e2.color',
                'e2.ex',
                'e2.same.color',
                'e2.same.ex',
                'e3',
                'e3.id',
                'e3.color',
                'e3.ex',
                'e3.same.color',
                'e3.same.ex',
                'e.changed',
                'e.mean',
                'e.std',
                
                // copy
                'copy',
                'copy.from.id',
                'copy.from.color',
                'copy.score',
                'copy.round',
                'copy.ex',
                 

                // time for
                'time.creation',
                'time.review',
                'time.dissemination',
                
                // distance 
                'd.pub.previous',
                'd.pub.cumulative',
                'd.sub.current',
                'd.self.previous',
                
                
];

///////////////////////////////////////////////
// START

var prefix = './data/';
var fileout = './data/ALL/pr_new2.csv';

var sessionData, PL, db, db_all, db_reviews, path; // shared by more functions

var writer = csv.createCsvStreamWriter(fs.createWriteStream(fileout));
writer.writeRecord(headings);	

var session = 'coo_rand_31_jan_2013';
merge(session);
return;


for (var session in sessions) {
	merge(session);
}

/////////////////////////////////////////////////////////////////
// FUNCTIONS

function merge(session) {
	path = prefix + session + '/';
	
	PL = pra.pl(path);
	db = pra.db(path, 'pr_full.nddb');
	db_all = pra.db(path, 'pr_4.3.30.nddb');

	db_reviews = new NDDB();
	db_reviews.load(path + 'all_reviews.nddb');
	db_reviews.h('player', function(e){
		return e.player;
	});
	db_reviews.rebuildIndexes();
	//console.log(db_reviews.first());
	
	sessionData = getSessionData(session);
	var fullRow;
	db.each(function(e) {
		fullRow = sessionData.concat(buildRoundRow(e, session));
		writer.writeRecord(fullRow);
	});
}

///////////////////////////////////////////////////////////////////

function getDistances(e) {
	if (!e.diff) return J.rep(['NA'], 4);
	var self = e.diff.self || 'NA';
	var pub = e.diff.pubs || 'NA';
	var pubCum = e.diff.pubsCum || 'NA';
	var sub = e.diff.others || 'NA';
	
	return [pub, pubCum, sub, self];
}

function getTimeFromFS(DIR, round) {
    var myStat = fs.statSync(DIR + '/' + 'pr_4.3.' + round + '.nddb');
    var dt = new Date(myStat.mtime);
    return dt.getTime();
}

function getTimeFromLoadedTable(session, round) {
	return times[session][round];
}


function getAllRoundTimesFromFS() {
	var times = {};
	
	var dir, myStat, dt, milliseconds;
	for (var session in sessions) {
		times[session] = {};
		for (var round = 1; round < 31 ; round++) {
			try {
				myStat = fs.statSync(sessions[session].serverdir + 'pr_4.3.' + round + '.nddb');
		        dt = new Date(myStat.mtime);
		        times[session][round] = dt.getTime();
			}
			catch (e) {
				console.log('An exception occurred ' + e);
				times[session][round] = 'NA';
			}
	         
		}
	}
	
	return times;
}



function getRelativeRoundTime(e, session) {
	
	var startTime_creation, startTime_review, startTime_diss;
	var stopTime_creation, stopTime_review, stopTime_diss;
	
	 
	startTime_creation = (e.state.round !== 1) ? getTimeFromLoadedTable(session, (e.state.round-1))
											   : 'NA';
	
	startTime_review = (db_all.state['4.1.' + e.state.round]) ? db_all.state['4.1.' + e.state.round].max('time')
										  					  : 'NA';
	
	startTime_diss = (db_all.state['4.2.' + e.state.round]) ? db_all.state['4.2.' + e.state.round].max('time')
															: 'NA';
	
	stopTime_creation = (db_all.state['4.1.' + e.state.round]) ? db_all.state['4.1.' + e.state.round].select('player', '=', e.player.id)
																									 .select('key', '=', 'CF')
																									 .first()
															   : 'NA';
	
	stopTime_creation = stopTime_creation ? stopTime_creation.time : 'NA';
	

	stopTime_review = (db_all.state['4.2.' + e.state.round]) ? db_all.state['4.2.' + e.state.round].select('player', '=', e.player.id)
														  										   .select('key', '=', 'EVA')
														  										   .first()
														  	  : 'NA';
	
	stopTime_review = stopTime_review ? stopTime_review.time : 'NA';
	
	stopTime_diss = getTimeFromLoadedTable(session, e.state.round);
	
	
	return [
	        (startTime_creation == 'NA' || stopTime_creation == 'NA') ? 'NA' : (stopTime_creation - startTime_creation) / 1000,
	        (startTime_review == 'NA' || stopTime_review == 'NA') ? 'NA' : (stopTime_review - startTime_review) / 1000,
	        (startTime_diss == 'NA' || stopTime_diss == 'NA') ? 'NA' : (stopTime_diss - startTime_diss) / 1000
	        ];
}

function getCopyData(e) {
	if (!e.copy) {
		return [0, 'NA', 'NA', 'NA', 'NA', 'NA'];
	}
	else {
		return [1, 
		        e.copy.copied_from.id,
		        e.copy.copied_from.color,
		        e.copy.copied_score,
		        e.copy.copied_round,
		        e.copy.copied_ex,
		        ];
	}
}

function getRound(e) {
	return e.state.round;
}

function getTreatments(dir) {
	var coo, com, rand, choice;
	
	if (dir.indexOf("coo") !== -1) {
		coo = 1;
		com = 0;
	}
	else {
		com = 1;
		coo = 0;
	}
	
	if (dir.indexOf("choice") !== -1) {
		choice = 1;
		rand = 0;
	}
	else {
		rand = 1;
		choice = 0;
	}
	
	return [com, coo, choice, rand];
	
}

function getNormalizedCFValues(e) {
	var cf = J.subobj(e.value, featnames);
	
	for (var f in cf) {
		if (cf.hasOwnProperty(f)) {
			cf[f] = normalizeFeature(f, cf[f]);
		}
	}
	
	return J.obj2Array(cf);
}

function normalizeFeature(feat, value, scale) {
	scale = scale || 100;
	var range = pra.features[feat].max - pra.features[feat].min;
	var newValue = Math.abs(value - pra.features[feat].min) / range;
	return newValue * scale; 
}

function getSessionData(dir) {
	var s = sessions[dir];
	var treats = getTreatments(dir);
	return [
        	s.id,
        	s.date,
        	s.morn,
        	s.after
	].concat(treats);
}

function getPlayerData(e) {
	return [e.player.id, e.player.pc, e.player.color];
}

function getCFValues(e) {
	return J.obj2Array(J.subobj(e.value, featnames));
}

function getPublished(e) {
	if (e.published) return 1;
	return 0;
}

function getReviews(e) {
	
	if (!e.reviewers) {
		return J.rep(['NA'], 9);
	}
	
	var p = e.player;
	var reviewers = [];
//	console.log(e)
	var V = 0; // variance
	for (var i = 0 ; i < e.reviewers.length ; i ++) {
		var rid = e.reviewers[i];
		var r = PL.get(rid);
		
		var score = e.scores[i];
		var ex = retrieveEx(p.id, e.state.round);
		var samecolor = (r.color === p.color) ? 1 : 0;
		var sameex = (r.ex === ex) ? 1 : 0;
	
		var hasChanged = retrieveChangedReview(r.id, e.state.round);
		
		V += Math.pow(score - e.avg, 2);
		
		reviewers.push(score);
		reviewers.push(r.id);
		reviewers.push(r.color);
		reviewers.push(ex);
		reviewers.push(samecolor);
		reviewers.push(sameex);
		reviewers.push(hasChanged);
		
	}
	
	reviewers.push(e.avg);
	reviewers.push(Math.sqrt(V));

	
	return reviewers;
	
}

function getEvaluations(e) {
	
	var p = e.player;
	var evas = [];
	
	var roundEvas = retrieveEvas(p.id, e.state.round);
	
	var totScore = 0; // variance
	var myEvas = [];
	var hasChanged;
	for (var i = 0 ; i < roundEvas.length ; i ++) {
		var eva = roundEvas[i];
		
		totScore += eva.score;
		myEvas.push(eva.score);
		hasChanged = eva.hasChanged;
		
		evas.push(eva.score);
		evas.push(eva.who);
		evas.push(eva.outcolor);
		evas.push(eva.outex);
		evas.push(eva.samecolor);
		evas.push(eva.sameex);
	}

	var avgEva = totScore / roundEvas.length;
	
	var V = 0;
	for (var i = 0; i < myEvas.length; i++) {
		V += Math.pow(myEvas[i] - avgEva, 2);
	}
	
	evas.push(hasChanged);
	evas.push(avgEva);
	evas.push(Math.sqrt(V));

	
	return evas;
	
}


function retrieveEx(player, round) {
	return db.player[player].select('state.round', '=', round).first().ex;
}

function retrieveChangedReview(player, round) {
	return db_reviews.player[player].select('round', '=', round).first().hasChanged;
}

function retrieveEvas(player, round) {
	return db_reviews.player[player].select('round', '=', round).fetch();
}


function buildRoundRow(e, session) {
	var player = getPlayerData(e);
	var round = getRound(e);
	
	if (e.state.round > 26 && session === 'coo_rand_7_feb_2013') {
		var cf = J.rep(['NA'], 13);
		var cf_norm = J.rep(['NA'], 13);
		var ex_and_pub = ['NA', 'NA'];
		var reviews = J.rep(['NA'], 23);
		var evas = J.rep(['NA'], 21);
		var copy = J.rep(['NA'], 6);
		var time = J.rep(['NA'], 3);
	} else {
		var cf = getCFValues(e);
		var cf_norm = getNormalizedCFValues(e);
		var published = getPublished(e);
		var ex_and_pub = [e.ex, published];
		var reviews = getReviews(e);
		var evas = getEvaluations(e);
		var copy = getCopyData(e);
		var time = getRelativeRoundTime(e, session);
	}
	
	var distances = getDistances(e);
	
	//console.log(time)
	
	var row = player.concat([round])
					.concat(cf)
					.concat(cf_norm)
					.concat(ex_and_pub)
					.concat(reviews)
					.concat(evas)
					.concat(copy)
					.concat(time)
					.concat(distances);
	
	return row;
}
