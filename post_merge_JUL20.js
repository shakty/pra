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
var fileout = './data/ALL/allnew_20JUL.csv';


var writer = csv.createCsvStreamWriter(fs.createWriteStream(fileout));
writer.writeRecord(headings);		

console.log(pra);


return;
db.loadCSV(filein, function(o) {
    console.log('DONE');
    //writer.writeRecord(J.obj2Array(i));
    
for (s in unique(pr$session)) {
  for (r in unique(pr$round)) {
    tmp <- pr[pr$session == s & pr$round == r,]
    for (p in unique(tmp$p.id)) {
      row <- tmp[tmp$p.id == p,]
      f <- getFace(s,r,p,tmp) # own face
      f1 <- getFace(s,r,row$e1.id,tmp)
      f2 <- getFace(s,r,row$e2.id,tmp)
      f3 <- getFace(s,r,row$e3.id,tmp)
      f1d <- getFaceDist(f,f1)
      f2d <- getFaceDist(f,f2)
      f3d <- getFaceDist(f,f3)
      # this works as long as p.id is unique across all sessions
      # somehow I cannot select both session and p.id ...
      pr[pr$round == r & pr$p.id == p,]$e1.d <- f1d
      pr[pr$round == r & pr$p.id == p,]$e2.d <- f2d
      pr[pr$round == r & pr$p.id == p,]$e3.d <- f3d
      pr[pr$round == r & pr$p.id == p,]$e.d <- mean(c(f1d,f2d,f3d))
      # for convenience adding diff from d.pub.previous
      pr[pr$round == r & pr$p.id == p,]$e1.d.pub.previous <- ifelse(is.na(row$e1.id), NA, tmp[tmp$p.id == row$e1.id, "d.pub.previous"])
      pr[pr$round == r & pr$p.id == p,]$e2.d.pub.previous <- ifelse(is.na(row$e2.id), NA, tmp[tmp$p.id == row$e2.id, "d.pub.previous"])
      pr[pr$round == r & pr$p.id == p,]$e3.d.pub.previous <- ifelse(is.na(row$e3.id), NA, tmp[tmp$p.id == row$e3.id, "d.pub.previous"])
    }
  }
}
    

});


