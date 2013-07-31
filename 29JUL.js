var fs = require('fs'),
	path = require('path'),
	csv = require('ya-csv'),
	NDDB = require('NDDB').NDDB,
	J = require('JSUS').JSUS,
	d3 = require('d3'),
	pra = require('pra-core');


var times = fs.readFileSync('./data/times.js', 'utf-8');
	times = JSON.parse(times);

var distFromAvgFace = pra.R.distanceFromAvgFace;
var computeAvgFace = pra.R.averageFace;
var getAvgFaceDistanceFromGroup = pra.R.getAvgFaceDistanceFromGroup;

var fnames = pra.featnamesR.all;

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
    'dfa.sub.curr',

    // distance from faces in other sessions
    'dse.pub.prev.1',
    'dse.sub.curr.1',
    'dse.pub.cum.1',
    'dse.pub.prev.2',
    'dse.sub.curr.2',
    'dse.pub.cum.2',
    'dse.pub.prev.3',
    'dse.sub.curr.3',
    'dse.pub.cum.3',
    'dse.pub.prev.4',
    'dse.sub.curr.4',
    'dse.pub.cum.4',
    'dse.pub.prev.5',
    'dse.sub.curr.5',
    'dse.pub.cum.5',
    'dse.pub.prev.6',
    'dse.sub.curr.6',
    'dse.pub.cum.6',
    'dse.pub.prev.7',
    'dse.sub.curr.7',
    'dse.pub.cum.7',
    'dse.pub.prev.8',
    'dse.sub.curr.8',
    'dse.pub.cum.8',
    'dse.pub.prev.9',
    'dse.sub.curr.9',
    'dse.pub.cum.9',
    'dse.pub.prev.10',
    'dse.sub.curr.10',
    'dse.pub.cum.10',
    'dse.pub.prev.11',
    'dse.sub.curr.11',
    'dse.pub.cum.11',
    'dse.pub.prev.12',
    'dse.sub.curr.12',
    'dse.pub.cum.12',
    'dse.pub.prev.13',
    'dse.sub.curr.13',
    'dse.pub.cum.13',
    'dse.pub.prev.14',
    'dse.sub.curr.14',
    'dse.pub.cum.14',
    'dse.pub.prev.15',
    'dse.sub.curr.15',
    'dse.pub.cum.15',
    'dse.pub.prev.16',
    'dse.sub.curr.16',
    'dse.pub.cum.16',

    'dse.pub.prev.mean.com',
    'dse.pub.prev.mean.coo',
 
    'dse.pub.prev.sd.com',
    'dse.pub.prev.sd.coo',  

    'dse.pub.cum.mean.com',
    'dse.pub.cum.mean.coo',

    'dse.pub.cum.sd.com',
    'dse.pub.cum.sd.coo',  

    'dse.sub.curr.mean.com',
    'dse.sub.curr.mean.coo',

    'dse.sub.curr.sd.com',
    'dse.sub.curr.sd.coo',

    'dse.pub.prev.mean',
    'dse.pub.prev.sd',
    'dse.pub.cum.mean',
    'dse.pub.cum.sd',
    'dse.sub.curr.mean',
    'dse.sub.curr.sd'
    
];

///////////////////////////////////////////////
// START


var db = new NDDB();

var DRYRUN = true;

var filein = './data/ALL/allnew_23jul.csv';
var fileout = './data/ALL/allnew_29jul.csv';


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

var db2 = new NDDB(); // here we save new computations

var meanArr = function(ar) {
    var sum, x;
    sum = 0;
    for(x = 0; x < ar.length; x++) {
        sum = sum + ar[x];
    }
    return sum / ar.length; 
}

var sdComp = function(sum, sum2, N) {
    return Math.sqrt((sum2 - (Math.pow(sum,2) / N)) / (N-1))
}

//return;
db.loadCSV(filein, function(o) {
    console.log('LOADED');
    //writer.writeRecord(J.obj2Array(i));
    console.log(db.size());
    db.rebuildIndexes();

    // Distance between published faces
    var s, r, tmpdbSession, tmpdbRoundprev, tmpdbRound, tmpdbRoundOwn;
    var face, faces, facesRound, pubFacesOld, pubFacesOldCum, subFacesOld;
    var avgFaceRound;
    var dbCumRound;
    var dse_pubprev, dse_pubcum, dse_subcurr;
    var sseq;
    var COO_pubprev_sum, COO_pubprev_sum2,
        COM_pubprev_sum, COM_pubprev_sum2,
        COO_pubcum_sum, COO_pubcum_sum2,
        COM_pubcum_sum, COM_pubcum_sum2,
        COO_subcurr_sum, COO_subcurr_sum2,
        COM_subcurr_sum, COM_subcurr_sum2;

    var COMcount, COOcount, COMcountPub, COOcountPub;
    
    for (s = 1; s < 17; s++) {
        tmpdbSession = db.session[s];
        
        for (r = 1; r < 31; r++) {

            tmpdbRoundOwn = db.sessionround[s + '_' + r];
            
            J.each(plnumbers, function(p) {
                
                var player, ss;
                player = tmpdbRoundOwn.selexec('p.number', '=', p);
                if (player.size() !== 1) {
                    console.log('Opss! Something wrong happened');
                }
                player = player.first();
               
                face = pra.R.getFaceFromRow(player);

                if (J.isEmpty(face)) {
                    debugger;
                }
         
                COO_pubprev_sum = 0, COM_pubprev_sum2 = 0,
                COO_pubcum_sum = 0, COM_pubcum_sum2 = 0,
                COO_subcurr_sum = 0, COM_subcurr_sum2 = 0
                COO_pubprev_sum2 = 0, COM_pubprev_sum = 0,
                COO_pubcum_sum2 = 0, COM_pubcum_sum = 0,
                COO_subcurr_sum2 = 0, COM_subcurr_sum = 0;
                COOcount = 0, COMcount = 0, COOcountPub = 0, COMcountPub = 0;
                

                // Compare every player with the faces of the other sessions
                for (ss = 1; ss < 17; ss++) {

                    // session 14 NAs
                    if (s == 14 && r > 26 ||
                        // other sessions against session 14 NAs
                        ss == 14 && r > 26 ||
                        // same session against itself
                        ss == s) {
                        dse_pubprev = 'NA';
                        dse_pubcum = 'NA';
                        dse_subcurr = 'NA';
                    }
                    else {
                        tmpdbRound = db.sessionround[ss + '_' + r];
                        if ('undefined' === typeof tmpdbRound) {
                            debugger;
                        }
                        facesRound = tmpdbRound.fetchSubObj(fnames);
                        
                        dse_subcurr = getAvgFaceDistanceFromGroup(face, facesRound);

                        if (isNaN(dse_subcurr)) {
                            debugger;
                        }
                        
                        if (r === 1) {
                            dse_pubprev = 'NA';
                            dse_pubcum = 'NA';
                        }
                        else {
                            tmpdbRoundPrev = db.sessionround[ss + '_' + (r-1)];
                            
                            // Published at R-1
                            pubFacesOld = pra.R.getPublishedFaces(tmpdbRoundPrev, r-1, false);

                            if (pubFacesOld.length === 0) {
                                dse_pubprev = 'NA';
                            }
                            else {
                                dse_pubprev = getAvgFaceDistanceFromGroup(face, pubFacesOld);
                                if (isNaN(dse_pubprev)) {
                                    debugger;
                                }
                            }

                            // Published until R-1
                            pubFacesOldCum = pra.R.getPublishedFaces(tmpdbRoundPrev, r-1, true);
                            if (pubFacesOldCum.length === 0) {
                                dse_pubcum = 'NA';
                            }
                            else {
                                dse_pubcum = getAvgFaceDistanceFromGroup(face, pubFacesOldCum);
                                if (isNaN(dse_pubcum)) {
                                    debugger;
                                }
                            }
                        }

                        
                        if (tmpdbRound.first().com === "1") {
                            COMcount++;
                            COM_subcurr_sum += dse_subcurr;
                            COM_subcurr_sum2 += Math.pow(dse_subcurr,2);
                            COM_pubcum_sum += dse_pubcum;
                            COM_pubcum_sum2 += Math.pow(dse_pubcum,2);
                            
                            if (!isNaN(dse_pubprev)) {
                                COM_pubprev_sum += dse_pubprev;
                                COM_pubprev_sum2 += Math.pow(dse_pubprev,2);
                                COMcountPub++;    
                            }
           
                        }
                        else {
                            COOcount++;
                            COO_subcurr_sum += dse_subcurr;
                            COO_subcurr_sum2 += Math.pow(dse_subcurr,2);
                            COO_pubcum_sum += dse_pubcum;
                            COO_pubcum_sum2 += Math.pow(dse_pubcum,2);
                            
                            if (!isNaN(dse_pubprev)) {
                                COO_pubprev_sum += dse_pubprev;
                                COO_pubprev_sum2 += Math.pow(dse_pubprev,2);
                                COOcountPub++;
                            }
                        }
                    }

                    //console.log(dse_pubprev);
                    //console.log(dse_pubcum);
                    //console.log(dse_subcurr);

                    player['dse.pub.prev.' + ss] = dse_pubprev;
                    player['dse.sub.curr.' + ss] = dse_subcurr;
                    player['dse.pub.cum.' + ss] = dse_pubcum;

                }
                
                // Previous pubs measures are not defined at round 1
                if (r == 1) {
                    player['dse.pub.prev.mean.com'] = 'NA'; 
                    player['dse.pub.prev.mean.coo'] = 'NA'; 
                    
                    player['dse.pub.prev.sd.com'] = 'NA'; 
                    player['dse.pub.prev.sd.coo'] = 'NA';
                    
                    
                    player['dse.pub.cum.mean.com'] = 'NA';
                    player['dse.pub.cum.mean.coo'] = 'NA'; 
                    
                    
                    player['dse.pub.cum.sd.com'] = 'NA'; 
                    player['dse.pub.cum.sd.coo'] = 'NA';

                }
                else {
                    player['dse.pub.prev.mean.com'] = COMcountPub ? COM_pubprev_sum / COMcountPub : 'NA'; 
                    player['dse.pub.prev.mean.coo'] = COOcountPub ? COO_pubprev_sum / COOcountPub : 'NA'; 
                    
                    player['dse.pub.prev.sd.com'] = COMcount ? sdComp(COM_pubprev_sum, COM_pubprev_sum2, COMcount) : 'NA'; 
                    player['dse.pub.prev.sd.coo'] = COOcount ? sdComp(COO_pubprev_sum, COO_pubprev_sum2, COOcount) : 'NA';
                    
                    
                    player['dse.pub.cum.mean.com'] = COMcount ? COM_pubcum_sum / COMcount : 'NA';
                    player['dse.pub.cum.mean.coo'] = COOcount ? COO_pubcum_sum / COOcount : 'NA'; 
                    
                    
                    player['dse.pub.cum.sd.com'] = COMcount ? sdComp(COM_pubcum_sum, COM_pubcum_sum2, COMcount) : 'NA'; 
                    player['dse.pub.cum.sd.coo'] = COOcount ? sdComp(COO_pubcum_sum, COO_pubcum_sum2, COOcount) : 'NA';
                }
  
                                  
                // SUB.CURR always exists
                player['dse.sub.curr.mean.com'] = COMcount ? COM_subcurr_sum / COMcount : 'NA';
                player['dse.sub.curr.mean.coo'] = COOcount ? COO_subcurr_sum / COOcount : 'NA';
                    
                    
                player['dse.sub.curr.sd.com'] = COMcount ? sdComp(COM_subcurr_sum, COM_subcurr_sum2, COMcount) : 'NA';
                player['dse.sub.curr.sd.coo'] = COOcount ? sdComp(COO_subcurr_sum, COO_subcurr_sum2, COOcount) : 'NA';
                
                if (COMcount && COOcount) {
                    player['dse.pub.cum.mean'] = (COM_pubcum_sum + COO_pubcum_sum) / 2;
                    player['dse.pub.cum.sd'] = sdComp(COO_pubcum_sum + COM_pubcum_sum,
                                                      COO_pubcum_sum2 + COM_pubcum_sum2,
                                                      COOcount + COMcount);

                    player['dse.sub.curr.mean'] = (COM_subcurr_sum + COO_subcurr_sum) / 2;
                    player['dse.sub.curr.sd'] = sdComp(COO_subcurr_sum + COM_subcurr_sum,
                                                       COO_subcurr_sum2 + COM_subcurr_sum2,
                                                       COOcount + COMcount);
                }
                else if (!COMcount && COOcount) {
                    player['dse.pub.cum.mean'] = player['dse.pub.cum.mean.coo'];
                    player['dse.pub.cum.sd'] = player['dse.pub.cum.sd.coo'];

                    player['dse.sub.curr.mean'] =  player['dse.sub.curr.mean.coo'];
                    player['dse.sub.curr.sd'] = player['dse.sub.curr.sd.coo'];
                }
                else if (COMcount && !COOcount) {
                    player['dse.pub.cum.mean'] = player['dse.pub.cum.mean.com'];
                    player['dse.pub.cum.sd'] = player['dse.pub.cum.sd.com'];

                    player['dse.sub.curr.mean'] =  player['dse.sub.curr.mean.com'];
                    player['dse.sub.curr.sd'] = player['dse.sub.curr.sd.com'];
                }
                else {
                    player['dse.pub.cum.mean'] = 'NA';
                    player['dse.pub.cum.sd'] = 'NA';

                    player['dse.sub.curr.mean'] = 'NA';
                    player['dse.sub.curr.sd'] = 'NA';
                }
                
                if (COMcountPub && COOcountPub) {
                    player['dse.pub.prev.mean'] = (COM_pubprev_sum + COO_pubprev_sum) / 2;
                    player['dse.pub.prev.sd'] = sdComp(COO_pubprev_sum + COM_pubprev_sum,
                                                       COO_pubprev_sum2 + COM_pubprev_sum2,
                                                       COOcountPub + COMcountPub);
                }
                else if (!COMcountPub && COOcountPub) {
                    player['dse.pub.prev.mean'] = player['dse.pub.prev.mean.coo'];
                    player['dse.pub.prev.sd'] =  player['dse.pub.prev.sd.coo'];

                }
                else if (COMcountPub && !COOcountPub) {
                    player['dse.pub.prev.mean'] = player['dse.pub.prev.mean.com'];
                    player['dse.pub.prev.sd'] =  player['dse.pub.prev.sd.com'];
                }
                else {
                    player['dse.pub.prev.mean'] = 'NA';
                    player['dse.pub.prev.sd'] = 'NA';
                }

                // resetting some of the values;
                if (r == 1) {
                    player['dse.pub.prev.mean'] = 'NA';
                    player['dse.pub.prev.sd'] = 'NA';

                    player['dse.pub.cum.mean'] = 'NA';
                    player['dse.pub.cum.sd'] = 'NA';
                }

                if ('number' === typeof player['dse.pub.prev.mean.coo'] && isNaN(player['dse.pub.prev.mean.coo'])) {
                    
                    debugger;
                }

                writer.writeRecord(J.obj2Array(player));
            });
        }
    }

    
    
    
    
    
});


