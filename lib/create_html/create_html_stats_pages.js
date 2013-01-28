var fs = require('fs'),
	path = require('path'),
	csv = require('ya-csv'),
	NDDB = require('NDDB').NDDB,
	d3 = require('d3');




//filenames = db.fetch();

var html = d3.select('html')
//				.append('span')
//				.text('The following charts show normalized differences between face submissions. Where the parameter is not explicitly mentioned, it is an average over all the 13 parameters of a face.') 
//				.append('br')
//				.append('span')
//					.text('The title ending reveals if the difference is computed against the previous submission of the same player or against the current submission of all the others.')
//				.append('ul')
//					.append('li')
//						.text('_mean.csv: average difference from all the other faces in the same round')
//					.append('li')
//						.text('_self.csv:   difference from the submission of the same player in the previous round')

function createListofImages(DIR, imgDir, out, cb) {

	out = DIR + 'html/' + out;
	var filenames = fs.readdirSync(DIR + imgDir);
	filenames.sort();
	
	d3.selectAll('table').remove();
	d3.select('dl').remove();
	var dl = html.append('dl');

	dl.selectAll('dt')
		.data(filenames)
		.enter()
		.append('dt')
			.append('img')
			.attr('src', function(f){
				return '../' + imgDir + f;
			});


	fs.writeFile(out, window.document.innerHTML, function(err) {
	    if(err) {
	        console.log(err);
	    } else {
	        console.log(out + " was saved!");
	    }
	    
	    if (cb) {
	    	cb(null);
	    }
	}); 

}

function diff_single_features(DIR, cb) {
	// SINGLE FEATURES
	createListofImages(DIR, 'csv/diff/single/img/', 'index_diff_faces_single.htm', cb);	
}

function diff_grouped_features(DIR, cb) {
	// GROUPED
	createListofImages(DIR, 'csv/diff/parts/img/', 'index_diff_faces_grouped.htm', cb);	
}

function diff_global_features(DIR, cb) {
	// GLOBAL
	createListofImages(DIR, 'csv/diff/global/img/', 'index_diff_faces_global.htm', cb);	
}

function diff_copies(DIR, cb) {
	// COPY
	createListofImages(DIR, 'csv/copy/img/', 'index_copy_in_time.htm', cb);
}

function diff_self(DIR, cb) {
	// SELF
	 createListofImages(DIR, 'csv/diff/self/img/', 'index_diff_faces_self.htm', cb);	
}

function diff_pubs(DIR, cb) {
	// PUBS
	 createListofImages(DIR, 'csv/diff/pubs/img/', 'index_diff_faces_pubs.htm', cb);
}

function diff_previous_pubs(DIR, cb) {
	// DIFF PUBS
	 createListofImages(DIR, 'csv/diff/previouspub/img/', 'index_diff_faces_previouspub.htm', cb);	
}

function diff_diff_and_score(DIR, cb) {
	// DIFFs and SCORE
	 createListofImages(DIR, 'csv/diff/diffandscore/img/', 'index_diffandscore.htm', cb);	
}

function diff_subs(DIR, cb) {
	// SUBMISSION DECISION
	createListofImages(DIR, 'csv/sub/img/', 'index_subs.htm', cb);	
}

function diff_ingroup_outgroup(DIR, cb) {
	// INGROUP-OUTGROUP
	createListofImages(DIR, 'csv/ingroup/img/', 'index_ingroup.htm', cb);
}

function diff_evas(DIR, cb) {
	// EVALUATIONS
	createListofImages(DIR, 'csv/eva/img/', 'index_evas.htm', cb);	
}

function create_all_html(DIR, cb) {

	diff_single_features(DIR, function() {
		diff_grouped_features(DIR, function() {
			diff_global_features(DIR, function() {
				diff_copies(DIR, function() {
					diff_self(DIR, function() {
						diff_pubs(DIR, function() {
							diff_previous_pubs(DIR, function() {
								diff_diff_and_score(DIR, function() {
									diff_subs(DIR, function() {
										diff_ingroup_outgroup(DIR, function() {
											diff_evas(DIR, function() {
												
												// LAST NESTED CALL
												if (cb) {
													cb(null);
												}
												/////////////
											});
										});
									});
								});
							});
						});
					});
				});
			});
		});
	});

}

module.exports = {
		create_html_stats_all: create_all_html,
		create_html_stats_diff_evas: diff_evas,
		create_html_stats_diff_ingroup_outgroup: diff_ingroup_outgroup,
		create_html_stats_diff_subs: diff_subs,
		create_html_stats_diff_diff_and_score: diff_diff_and_score,
		create_html_stats_diff_previous_pubs: diff_previous_pubs,
		create_html_stats_diff_pubs: diff_pubs,
		create_html_stats_diff_self: diff_self,
		create_html_stats_diff_copies: diff_copies,
		create_html_stats_diff_global_features: diff_global_features,
		create_html_stats_diff_grouped_features: diff_grouped_features,
		create_html_stats_diff_single_features: diff_single_features,
};