var fs = require('fs'),
path = require('path'),
csv = require('ya-csv'),
NDDB = require('NDDB').NDDB,
J = require('JSUS').JSUS,
d3 = require('d3'),
pr_stats = require('pra-core');

module.exports = create_html_by_player;

var getFileName = require('./getFileName');

var getHtmlFromItem = require('./getHtmlFromItem');

function sortByPlayerId(a, b) {
    if (a.player > b.player) return -1;
    if (a.player < b.player) return 1;
    return 0;
}

function create_html_by_player(db, DIR, cb) {
    var group, treatment, session;
    var firstItem, indexFilename;

    var html, table, thead, tbody, rows;

    // Might be called multiple times on same db.
    if (!db.round) {
        db.sort('round');
        db.hash('round');
        db.hash('player');
        db.hash('ex');

        db.hash('copies', function(e) {
            return;
            if (!e.copies) return;
            return e.copy.copied_from.id + '_' + e.copy.copied_round;
        });

        db.rebuildIndexes();
    }

    indexFilename = DIR + 'index_player';

    firstItem = db.first();
    group = firstItem.group;
    treatment = firstItem.treatment;
    session = firstItem.session;

    indexFilename += '_' + group + '_' + treatment + '_' + session + '.htm';


    // Setup variables.
    //////////////////////

    var plIds = Object.keys(db.player).sort();

    var copies = J.obj2Array(db.copies, 1);

    var thcopies = Object.keys(db.copies);

    var rounds = db.groupBy('round');

    // Clean up because d3 keeps previous html structures (if in loop).
    d3.selectAll('table').remove();
    d3.selectAll('dl').remove();
    d3.selectAll('script').remove();
    d3.selectAll('div').remove();
    d3.selectAll('style').remove();

    // Begin.
    
    html = d3.select('html');

    html.append('style')
        .attr('type', 'text/css')
        .text('.copies {border: 1px solid #CCC; vertical-align: top; width: 100px}');


    table = html.append('table');
    thead = table.append("thead"),
    tbody = table.append("tbody");

    // Append the header row with the id of all players.
    thead.append("tr")
        .selectAll("th")
        .data(plIds)
        .enter()
        .append("th")
        .text(function(pId) {
            return pId;
        });

    // Create a row for each round.
    rows = tbody.selectAll("tr")
        .data(rounds)
        .enter()
        .append("tr");

    // Create a cell in each row for each player.
    var playerCounter = 0;
    var roundCounter = 0;
    rows.selectAll("td")
        .data(plIds)
        .enter()
        .append("td")
        .html(function(pid) {
            var data;
            data = rounds[roundCounter];
            data.sort(sortByPlayerId);
            if (++playerCounter === 9) {
                playerCounter = 0;
                roundCounter++;
            }
            if (!data.db[playerCounter]) return;
            return getHtmlFromItem(data.db[playerCounter], { player: false });
        });

    // Save HTML file.
    fs.writeFile(indexFilename, window.document.innerHTML, function(err) {
        if (err) console.log(err);
        else console.log("The player file was saved: " + indexFilename);
        if (cb) cb(null);        
    });
    // Copy js controls, if necessary.
    fs.exists(DIR + 'page.control.js', function(exist) {
        if (exist) return;
        fs.createReadStream(__dirname + '/page.control.js')
            .pipe(fs.createWriteStream(DIR + 'page.control.js'));
    });
}

// function displayFace(item, player) {
//     var item, border, filename, pub, avg, style, content;
// 
//     filename = getFileName(item);
//     console.log(filename)
//     pub = item.published ? 'P' : 'NP';
//     avg = item.avg;
// 
//     //  console.log(avg)
// 
//     style =  "width: 150px; margin: 3px; border: 3px solid ";
//     style+= item.published ? "yellow;" : "#CCC";
//     content = '<img src="' + filename + '" style="' + style + '"/>';
//     content += '<br/>';
//     content += '<span style="text-align: center;">' + avg + '</span>';
//     content += '<span style="text-align: center;">' + item.ex + '</span>';
//     content += '&nbsp;<span >' + item.round + '</span>';
// 
//     if (player) {
//         content += '&nbsp;<span>' + item.player + '</span>';
//     }
// 
//     return content;
// }


// function create_html_copies_only(DIR, cb) {
//     // ONLY COPIES
// 
//     var db = pr_stats.db(DIR, 'all_cf_sub_eva_copy.nddb');
// 
//     db.hash('copies', function(e){
//         if (!e.copy) return;
//         return e.copy.copied_from.id + '_' + e.copy.copied_round;
//     });
// 
//     db.rebuildIndexes();
// 
//     // LOADING DEFAULTS
//     //////////////////////
// 
//     // PL
//     var pl = pr_stats.pl(DIR);
// 
//     var copies = J.obj2Array(db.copies,1);
// 
//     var thcopies = J.keys(db.copies);
//     //  console.log(thcopies);
// 
// 
//     var players = db.groupBy('player.id');
// 
// 
//     var rounds = db.groupBy('round');
// 
// 
//     // BEGIN
// 
//     d3.selectAll('table').remove();
// 
//     var html = d3.select('html');
// 
//     html.append('style')
//         .attr('type', 'text/css')
//         .text('.copies {border: 1px solid #CCC; vertical-align: top; width: 100px}');
// 
//     table = html.append('table');
//     thead = table.append("thead"),
//     tbody = table.append("tbody");
// 
//     //append the header row
//     thead.append("tr")
//         .selectAll("th")
//         .data(thcopies)
//         .enter()
//         .append("th")
//         .html(function(who_round) {
//             var tokens = who_round.split('_');
//             //                  console.log(tokens)
//             //                  console.log(db.first())
//             var face = db.select('player.id', '=', tokens[0])
//                 .select('state.round', '=', tokens[1]).first();
//             return displayFace(face, true);
//         });
// 
// 
//     // create a row for each object in the data
//     var rows = tbody.append("tr");
// 
// 
//     // create a cell in each row for each column
//     var cells = rows.selectAll("td")
//         .data(copies)
//         .enter()
//         .append("td")
//         .classed('copies', true)
//         .html(function(e) {
//             e.sort('state.round');
// 
//             var content = '';
//             e.each(function(item) {
//                 content += displayFace(item, true);
//                 //console.log(item);
//             });
//             return content;
//         });
// 
//     fs.writeFile(DIR + 'html/index_copies.htm', window.document.innerHTML, function(err) {
//         if (err) {
//             console.log(err);
//         } else {
//             console.log("The file copies was saved!");
//         }
// 
//         if (cb) {
//             cb(null);
//         }
//     });
// }
