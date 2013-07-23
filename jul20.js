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
    
    // assness of the reviewer
    'ass',
    'ass.kill',
    'ass.love'                
  
    // 
];

///////////////////////////////////////////////
// START


var db = new NDDB();

var DRYRUN = true;

var filein = './data/ALL/allnew.csv';
var fileout = './data/ALL/session_diffs.csv';


// var writer = csv.createCsvStreamWriter(fs.createWriteStream(fileout));
// writer.writeRecord(headings);		

console.log(pra.getAvgFaceDistanceFromGroup.toString());


db.hash('session', function(i) {
    return i.session;
});

db.hash('sessionround', function(i) {
    return i.session + '_' + i.round;
});

db.hash('player', function(i) {
    return i['p.id'];
});



var db2 = new NDDB(); // here we save new computations


//return;
db.loadCSV(filein, function(o) {
    console.log('DONE');
    //writer.writeRecord(J.obj2Array(i));
    console.log(db.size());
    db.rebuildIndexes();


    db.each(function(i) {
        var s,r,idx,pid,reviewer, meanAssKill, meanAssLove, mean5, tmpCount, rIdx;
        var r1err, r2err, r3err, cleanMean;
        var LOVE = 9.5;
        var KILL = 0.5;
        
        
        s = i.session;
        r = i.round;
        idx = s + '_' + r;
        tmpdb = db.sessionround[idx];
     
        pid = i['p.id'];
        
    

        i['r1.ass.kill'] = 0;
        i['r1.ass.love'] = 0;
        i['r2.ass.kill'] = 0;
        i['r2.ass.love'] = 0;
        i['r3.ass.kill'] = 0;
        i['r3.ass.love'] = 0;
        
        if (i['r1.id'] && i['r1.id'] !== 'NA') {
            
            reviewer = tmpdb.selexec('p.id', '=', i['r1.id']).first();
            rIdx = 0;
            
            
            if (reviewer['e1.id'] === pid) {
                rIdx = 'e1';
            }  
            else if (reviewer['e2.id'] === pid) {
                rIdx = 'e2';
            }  
            else if (reviewer['e3.id'] === pid) {
                rIdx = 'e3';
            }  
            else {
                console.log('Oops! Reviewer 1 not found!', pid);
            }
            
            if (rIdx) {     
                if (reviewer[rIdx + '.same.ex'] === '1' && parseFloat(reviewer[rIdx]) < KILL) {		    
                    i['r1.ass.kill'] = 1;
		}
                else if (parseFloat(reviewer[rIdx]) > LOVE) {
		    i['r1.ass.love'] = 1;
                }
            }
            
        }

        if (i['r2.id'] && i['r2.id'] !== 'NA') {
            
            reviewer = tmpdb.selexec('p.id', '=', i['r2.id']).first();
            rIdx = 0;

            if (reviewer['e1.id'] === pid) {
                rIdx = 'e1';
            }  
            else if (reviewer['e2.id'] === pid) {
                rIdx = 'e2';
            }  
            else if (reviewer['e3.id'] === pid) {
                rIdx = 'e3';
            }  
            else {
                console.log('Oops! Reviewer 2 not found!');
            }
            
            if (rIdx) {
                if (reviewer[rIdx + '.same.ex'] === '1' && parseFloat(reviewer[rIdx]) < KILL) {
		    i['r2.ass.kill'] = 1;
		}
                else if (parseFloat(reviewer[rIdx]) > LOVE) {
		    i['r2.ass.love'] = 1;
                }
            } 
            
        }
        
        if (i['r3.id'] && i['r3.id'] !== 'NA') {
            
            reviewer = tmpdb.selexec('p.id', '=', i['r3.id']).first();
            rIdx = 0;

            if (reviewer['e1.id'] === pid) {
                rIdx = 'e1';
            }  
            else if (reviewer['e2.id'] === pid) {
                rIdx = 'e2';
            }  
            else if (reviewer['e3.id'] === pid) {
                rIdx = 'e3';
            }  
            else {
                console.log('Oops! Reviewer 3 not found!');
            }
            
            if (rIdx) {
                if (reviewer[rIdx + '.same.ex'] === '1' && parseFloat(reviewer[rIdx]) < KILL) {
		    i['r3.ass.kill'] = 1;
		}
                else if (parseFloat(reviewer[rIdx]) > LOVE) {
		    i['r3.ass.love'] = 1;
                }
            } 
            
        }

        r1err = false, r2err = false, r3err = false;

        tmpCount = 0;
        mean5 = 0;
        if (i.r1 != '5' || i['r1.changed'] === '1') {
            mean5 = mean5 + parseFloat(i.r1);
            tmpCount++;
        }
        else {
            r1err = true;
        }
        if (i.r2 != '5' || i['r2.changed'] === '1') {
            mean5 = mean5 + parseFloat(i.r2);
            tmpCount++;
        }
        else {
            r2err = true;
        }
        if (i.r3 != '5' || i['r3.changed'] === '1') {
            mean5 = mean5 + parseFloat(i.r3);
            tmpCount++;
        }
        else {
            r3err = true;
        }
        i['r.mean.clean5'] = tmpCount ? (mean5 / tmpCount).toFixed(2) : 'NA';
        
        tmpCount = 0;
        meanAssKill = 0;
        if (i['r1.ass.kill'] === 0) {
            meanAssKill = meanAssKill + parseFloat(i.r1);
            tmpCount++;
        }
        else {
            r1err = true;
        }
        if (i['r2.ass.kill'] === 0) {
            meanAssKill = meanAssKill + parseFloat(i.r2);
            tmpCount++;
        }
        else {
            r2err = true;
        }
        if (i['r3.ass.kill'] === 0) {
            meanAssKill = meanAssKill + parseFloat(i.r3);
            tmpCount++;
        }
        else {
            r3err = true;
        }
        i['r.mean.clean.asskill'] = tmpCount ? (meanAssKill / tmpCount).toFixed(2) : 'NA';            
        
        tmpCount = 0;
        meanAssLove = 0;
        if (i['r1.ass.love'] === 0) {
            meanAssLove = meanAssLove + parseFloat(i.r1);
            tmpCount++;
        }
        else {
            r1err = true;
        }
        if (i['r2.ass.love'] === 0) {
            meanAssLove = meanAssLove + parseFloat(i.r2);
            tmpCount++;
        }
        else {
            r2err = true;
        }
        if (i['r3.ass.love'] === 0) {
            meanAssLove = meanAssLove + parseFloat(i.r3);
            tmpCount++;         
        }
        else {
            r3err = true;
        }
        i['r.mean.clean.asslove'] = tmpCount ? (meanAssLove / tmpCount).toFixed(2) : 'NA';  
        
        
        
        tmpCount = 0;  
        cleanMean = 0;
        if (!r1err) {
            cleanMean = cleanMean + parseFloat(i.r1);
            tmpCount++;
        }
        if (!r2err) {
            cleanMean = cleanMean + parseFloat(i.r2);
            tmpCount++;
        }
        if (!r3err) {
            cleanMean = cleanMean + parseFloat(i.r3);
            tmpCount++;
        }
        i['r.mean.clean'] = tmpCount ? (cleanMean / tmpCount).toFixed(2) : 'NA';  

        i.rmean = i['r.mean'];
        i.r15 = i['r1.changed'];
        i.r25 = i['r2.changed'];
        i.r35 = i['r3.changed'];
        i.r1b = i['r1'];
        i.r2b = i['r2'];
        i.r3b = i['r3'];
        
    
    });

    console.log(db.selexec('r1.ass.kill','=','1').shuffle().first());
    return;

    // Distance between published faces
    var s, r, tmpdb, pubFacesOld, pubFacesNew, dist;
    for (s = 1; s < 17; s++) {
        for (r = 1; r < 31; r++) {
          //  tmpdb = db.select('session','=',s)
          //      .select('round','=',r)
          //      .execute();

            tmpdb = db.sessionround[s + '_' + r];
            
            
            
            if (r === 1) {
                dist = 'NA';
            }
            else {
                pubFacesOld = pra.getPublishedFaces(tmpdb, r-1, false);
                pubFacesNew = pra.getPublishedFaces(tmpdb, r, false);
                if (pubFacesOld.size() === 0 || pubFacesNew.size() === 0) {
                    dist = 'NA';
                }
                else {
                    dist = getAvgFaceDistanceGroupFromGroup(pubFacesOld, pubFacesNew);
                }

            }
            
            // Do it from session to session

            db2.insert({
                session: s,
                round: r,
                'd.pub2pub': dist
            });
            
        }
    }

    
    
    
    
    
});


