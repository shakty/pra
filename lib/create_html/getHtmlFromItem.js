var getFileName = require('./getFileName');

module.exports = function getHtmlFromItem(item) {
    var content;
    content = '<div style="float: left">';

    filename = getFileName(item);

    avg = Number(item['r.mean.from']).toFixed(2);

    style =  "width: 150px; margin: 3px; border: 3px solid ";
    style+= item.published ? "yellow;" : "#CCC";

    content += '<img src="' + filename + '" style="' +  style + '"/>';
    content += '<br/>';
    content += '<span style="text-align: center;">' + avg + '</span>';

    // content += '&nbsp;<span style="text-align: center;">' +
    // item.ex + '</span>';

    content += '&nbsp;<span style="text-align: center;">' +
        item.round + '</span>';                      
    content += '&nbsp;<span style="text-align: center;">' +
        item.player + '</span>';
    content += '</div>';

    return content;
};