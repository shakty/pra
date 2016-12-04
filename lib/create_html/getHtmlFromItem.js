var getFileName = require('./getFileName');

module.exports = function getHtmlFromItem(item) {
    var content;
    content = '<div style="float: left">';

    filename = getFileName(item);

    avg = Number(item['r.mean.from']).toFixed(2);

    style =  "width: 150px; margin: 3px; border: 3px solid #CCC";

    content += '<img src="' + filename + '" style="' +  style + '"/>';
    content += '<br/>';


    if (item.published) {
        content += '<span style="font-weight: bold; text-align: center;">' +
            avg + '</span>';
    }
    else {
        content += '<span style="text-align: center;">' + avg + '</span>';
    }

    // content += '&nbsp;<span style="text-align: center;">' +
    // item.ex + '</span>';

    content += '&nbsp;<span style="text-align: center;">' +
        item.round + '</span>';                      
    content += '&nbsp;<span style="text-align: center;">' +
        item.player + '</span>';
    content += '</div>';

    return content;
};