var fs = require('fs'),
	path = require('path'),
	csv = require('ya-csv'),
	NDDB = require('NDDB').NDDB,
	JSUS = require('JSUS').JSUS,
	d3 = require('d3');


module.exports = create_html_exh;

function create_html_exh(DIR, ONLY_PUBLISHED, cb) {
	
	var db = new NDDB();
	
	db.hash('player', function(gb) {
		return gb.player;
	});
	db.hash('stage', function(gb) {
		return gb.stage.stage + '.' + gb.stage.step +  '.' + gb.stage.round;
	});
	db.h('ex', function(gb) {
		return gb.ex;
	});
	
	db.load(DIR + 'all_cf_sub_eva.nddb');
	
	db.each(function(e){
		e.stage.round = Number(e.stage.round);
	});
	
	
	db.sort(['stage.round']);
	db.rebuildIndexes();
	
	
	var exhs = JSUS.implodeObj(db.ex),
		exnames = ['A','B','C'];
	
	var index_file = (ONLY_PUBLISHED) ? DIR + 'html/index_exh_pub.htm'
									: DIR + 'html/index_exh.htm';
	
	var stages = db.groupBy('stage');
	
	//console.log('Rounds: ' + stages.length);
	//console.log('Exhibitions: ' + exhs.length);
	
	// Clean up
	d3.selectAll('table').remove();
	d3.select('dl').remove();
	
	var html = d3.select('html');
	
	html.append('script')
		.attr('src', './../lib/d3.v2.js');
	
	//html.append('button')
	//	.text('Switch')
	//	.attr('id','switch');
	//
	//function funcSwitch() {
	//	var b = document.getElementById('switch');
	//	b.onclick = function() {
	//		d3.select("body").transition()
	//		.duration(750)
	//		.delay(function(d, i) { return i * 10; })
	//	    .style("background-color", "black");
	//	};
	//	
	//};
	//
	//html.append('script')
	//	.text('(' + funcSwitch.toString() + ')()');
	
	///
	var table = html.append('table')
		 .style('width','98%')
	    thead = table.append("thead"),
	    tbody = table.append("tbody");
	
	// append the header row
	thead.append("tr")
	    .selectAll("th")
	    .data(['A','B','C'])
	    .enter()
	    .append("th")
	        .text(function(ex) { 
	        	return ex; 
	        });
	
	// create a row for each object in the data
	var rows = tbody.selectAll("tr")
	    .data(stages)
	    .enter()
	    .append("tr")
	    .style('border','1px solid #CCC');
	    
	
	//// create a cell in each row for each column
	
	var item, border, filename, avg, style, content;
	var localCount = 0, count = 1;
	var cells = rows.selectAll("td")
	    .data([db.ex.A, db.ex.B, db.ex.C])
	    .enter()
	    .append("td")
	    .style('border','1px solid #CCC')
	    	.html(function(ex) {
	    		localCount++;
	    		if (localCount === 4) {
	    			count++;
	    			localCount = 1;
	    		}
		        
	    		var items = ex.select('stage.round', '=', count);
	    		
		        //	item = ex.get();
				//Update pointer
				//ex.next();
		        	
					if (items && items.length) {
						content = '';
						items.each(function(item) {
							if (ONLY_PUBLISHED && !item.published) return;
							
							content += '<div style="float: left">';
							filename = './faces/' + item.player.pc + '_' + item.stage.round + '.png';
			            	//console.log(filename)
			        		avg = item.avg;
			        		style =  "width: 150px; margin: 3px; border: 3px solid ";
			        		style+= item.published ? "yellow;" : "#CCC";
			        		content += '<img src="../' + filename + '" style="' + style + '"/>';
			        		content += '<br/>';
			        		content += '<span style="text-align: center;">' + avg + '</span>';
	//		        		content += '&nbsp;<span style="text-align: center;">' + item.ex + '</span>';
			        		content += '&nbsp;<span style="text-align: center;">' + item.stage.round + '</span>';		        		
			        		content += '&nbsp;<span style="text-align: center;">' + item.player.pc + '</span>';
			        		content += '</div>';
			        		
						});
						return content;
					}
					else {
						return '-';
					}
					
					
	        		
	        		
		        		
		        });
	//			.attr('width',150)
	//			.style('margin', '3px')
	
	
	fs.writeFile(index_file, window.document.innerHTML, function(err) {
	    if(err) {
	        console.log(err);
	    } else {
	        console.log("File was saved! " + index_file);
	    }
	    
	    if (cb) {
	    	cb(null);
	    }
	}); 
}
