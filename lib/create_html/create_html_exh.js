'use strict';

var fs = require('fs'),
    path = require('path'),
    csv = require('ya-csv'),
    NDDB = require('NDDB').NDDB,
    JSUS = require('JSUS').JSUS,
    d3 = require('d3');

module.exports = create_html_exh;

var getHtmlFromItem = require('./getHtmlFromItem');

function create_html_exh(db, DIR, cb) {
    var group, treatment, session;
    var firstItem, indexFilename;
    var rounds;

    var html, table, thead, tbody, rows;

    var count, localCount;

    // Might be called multiple times on same db.
    if (!db.round) {
        db.sort('round');
        db.hash('round');
        db.hash('ex');
        db.rebuildIndexes();
    }

    indexFilename = DIR + 'index_exh';

    firstItem = db.first();
    group = firstItem.group;
    treatment = firstItem.treatment;
    session = firstItem.session;

    indexFilename += '_' + group + '_' + treatment + '_' + session + '.htm';

    rounds = db.groupBy('round');

    // Clean up because d3 keeps previous html structures (if in loop).
    d3.selectAll('table').remove();
    d3.selectAll('dl').remove();
    d3.selectAll('script').remove();
    d3.selectAll('div').remove();

    html = d3.select('html');

    html.append('div')
        .html('<strong>Group: </strong>' + group +
              ' <strong>Treatment: </strong>' + treatment +
              ' <strong>Session: </strong>' + session);

    html.append('div')
        .html('<strong>Images </strong>: ' +
              '<span id="images_all" style="font-weight: bold">All</span> | ' +
              '<span id="images_pub">Published</span> | ' +
              '<span id="images_rej">Rejected</span>');

    html.append('script')
        .attr('src', './page.control.js');


    // Not needed now.
    // html.append('script')
    //     .attr('src', './../lib/d3.v2.js');

    //html.append('button')
    //  .text('Switch')
    //  .attr('id','switch');
    //
    //function funcSwitch() {
    //  var b = document.getElementById('switch');
    //  b.onclick = function() {
    //      d3.select("body").transition()
    //      .duration(750)
    //      .delay(function(d, i) { return i * 10; })
    //      .style("background-color", "black");
    //  };
    //
    //};
    //
    //html.append('script')
    //  .text('(' + funcSwitch.toString() + ')()');

    ///

    table = html.append('table').style('width','98%');
    thead = table.append("thead"),
    tbody = table.append("tbody");

    // Append the header row.
    thead.append("tr")
        .selectAll("th")
        .data(['A','B','C'])
        .enter()
        .append("th")
        .text(function(ex) {
            return ex;
        });

    // Create a row for each object in the data.
    rows = tbody.selectAll("tr")
        .data(rounds)
        .enter()
        .append("tr")
        .style('border','1px solid #CCC');

    // Create a cell in each row for each column.

    // Counter for switching rounds/exhibitions.
    count = 1;
    localCount = 0;

    rows.selectAll("td")
        .data([db.ex.A || [], db.ex.B || [], db.ex.C || []])
        .enter()
        .append("td")
        .style('border','1px solid #CCC')
        .html(function(ex) {
            var items, content;

            localCount++;
            if (localCount === 4) {
                count++;
                localCount = 1;
            }

            items = ex.selexec('round', '=', count);

            items.sort(function(a, b) {
                if (a['r.mean.from'] > b['r.mean.from']) return -1;
                if (a['r.mean.from'] < b['r.mean.from']) return 1;
                return 0;
            });

            if (items && items.size()) {
                content = '';
                items.each(function(item) {
                    content += getHtmlFromItem(item);
                });
                return content;
            }
            else {
                return '-';
            }

        });

    //          .attr('width',150)
    //          .style('margin', '3px')

    // Write HTML to file.
    fs.writeFile(indexFilename, window.document.innerHTML, function(err) {
        if (err) console.log(err);
        else console.log("File was saved! " + indexFilename);
        if (cb) cb(null);
    });

    // Copy js controls, if necessary.
    fs.exists(DIR + 'page.control.js', function(exist) {
        if (exist) return;
        fs.createReadStream(__dirname + '/page.control.js')
            .pipe(fs.createWriteStream(DIR + 'page.control.js'));
    });
}
