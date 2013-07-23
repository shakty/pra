var fs = require('fs'),
	path = require('path'),
	csv = require('ya-csv'),
	NDDB = require('NDDB').NDDB,
	J = require('JSUS').JSUS,
	d3 = require('d3'),
	pra = require('pra-core');

var times = fs.readFileSync('./data/times.js', 'utf-8');
	times = JSON.parse(times);

var distFromAvgFace = pra.dist.distanceFromAvgFace;

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
    
    // assness of the reviewer
    'ass',
    'ass.kill',
    'ass.love',            
  
    // assness per review
    'r1.ass.kill',
    'r1.ass.love',
    'r2.ass.kill',
    'r2.ass.love',
    'r3.ass.kill',
    'r3.ass.love',

    // mean cleaned off the assness of the review
    'r.mean.clean5',
    'r.mean.clean.asskill',
    'r.mean.clean.asslove',
    'r.mean.clean',

    // distance from average face
    'dfa.pub.prev',
    'dfa.sub.prev',
    'dfa.pub.cum',
    'dfa.sub.curr'

];

///////////////////////////////////////////////
// START


var db = new NDDB();

var DRYRUN = true;

var filein = './data/ALL/allnew_20jul.csv';
var fileout = './data/ALL/allnew_23jul.csv';


var writer = csv.createCsvStreamWriter(fs.createWriteStream(fileout));
writer.writeRecord(headings);		

//console.log(pra.getAvgFaceDistanceFromGroup.toString());


db.hash('session', function(i) {
    return i.session;
});

db.hash('sessionround', function(i) {
    return i.session + '_' + i.round;
});

db.hash('player', function(i) {
    return i['p.id'];
});

var plnumbers = pra.plnumbers;
   debugger 

var db2 = new NDDB(); // here we save new computations


//return;
db.loadCSV(filein, function(o) {
    console.log('DONE');
    //writer.writeRecord(J.obj2Array(i));
    console.log(db.size());
    db.rebuildIndexes();

    // Distance between published faces
    var s, r, tmpdbSession, tmpdbRoundprev, tmpdbRound;
    var face, faces, facesRound, pubFacesOld, pubFacesNew;
    var dfa_pubprev, dfa_subprev, dfa_pubcum, dfa_subcurr;
    for (s = 1; s < 17; s++) {
        tmpdbSession = db.session[s];
        
        for (r = 1; r < 31; r++) {
            
            tmpdbRound = db.sessionround[s + '_' + r];
            facesRound = tmpdbRound.fetchSubObj([
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
                'f.mouth_bottom_y'
            ]);
            
            J.each(plnumbers, function(p) {
                var player;
                player = tmpdbRound.selexec('p.number', '=', p);
                if (player.size() !== 1) {
                    console.log('Opss! Something wrong happened');
                }
                player = player.first();
                face = pra.getFaceFromRow(player);
                
                dfa_subcurr = distFromAvgFace(face, facesRound);
                console.log(dfa_subcurr);
                
//                if (r === 1) {
//                    dfa_pubprev = 'NA';
//                    dfa_subprev = 'NA';
//                    dfa_pubcum = 'NA';
//                }
//                else {
//                    tmpdbRoundPrev = db.sessionround[s + '_' + r];
//                    
//                    pubFacesOld = pra.getPublishedFaces(tmpdb, r-1, false);
//                    pubFacesNew = pra.getPublishedFaces(tmpdb, r, false);
//                    if (pubFacesOld.size() === 0 || pubFacesNew.size() === 0) {
//                        dist = 'NA';
//                    }
//                    else {
//                        dist = getAvgFaceDistanceGroupFromGroup(pubFacesOld, pubFacesNew);
//                    }
//
//                }
                
                // Do it from session to session

//                db2.insert({
//                    session: s,
//                    round: r,
//                    'd.pub2pub': dist
//                });
            });
            

            
        }
    }

    
    
    
    
    
});


