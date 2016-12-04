var fs = require('fs'),
    path = require('path'),
    csv = require('ya-csv'),
    NDDB = require('NDDB').NDDB,
    JSUS = require('JSUS').JSUS,
    d3 = require('d3');

module.exports = create_html_exh;

var getHtmlFromItem = require('./getHtmlFromItem');

function create_html_exh(db, DIR, ONLY_PUBLISHED, cb) {

    // Might be called multiple times on same db.
    if (!db.round) {
        db.sort('round'); 
        db.hash('round');
        db.hash('ex');
        db.rebuildIndexes();
    }
    
    var indexFilename = ONLY_PUBLISHED ?
        DIR + 'index_exh_pub' : DIR + 'index_exh';
    
    var firstItem = db.first();
    indexFilename += '_' + firstItem.group + '_' + firstItem.treatment + '_' +
        firstItem.session + '.htm';

    var rounds = db.groupBy('round');
    
    // Clean up (d3 keeps previous html structures (if in loop).
    d3.selectAll('table').remove();
    d3.select('dl').remove();
    d3.select('script').remove();
    d3.select('div').remove();
    
    var html = d3.select('html');
    
    html.append('div')
        .html(indexFilename);

    html.append('script')
        .attr('src', './../lib/d3.v2.js');
    
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

    var table = html.append('table').style('width','98%');
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
    var rows = tbody.selectAll("tr")
        .data(rounds)
        .enter()
        .append("tr")
        .style('border','1px solid #CCC');
        
    // Create a cell in each row for each column.
    
    var item, border, filename, avg, style, content;

    // Counter for switching rounds/exhibitions.
    var localCount = 0, count = 1;

    var cells = rows.selectAll("td")
        .data([db.ex.A || [], db.ex.B || [], db.ex.C || []])
        .enter()
        .append("td")
        .style('border','1px solid #CCC')
        .html(function(ex) {
            var items;

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
                    if (ONLY_PUBLISHED && !item.published) return;                    
                    content += getHtmlFromItem(item);
                });
                return content;
            }
            else {
                debugger
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
}
