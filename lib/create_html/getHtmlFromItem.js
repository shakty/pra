var getFileName = require('./getFileName');

module.exports = function getHtmlFromItem(item) {
    var avg, style, content;

    content = '<div class="img-container" style="float: left">';

    filename = getFileName(item);

    avg = Number(item['r.mean.from']).toFixed(2);

    style =  "width: 150px; margin: 3px; border: 3px solid #CCC";

    if (item.published) {
        content += '<img class="published" src="' + filename +
            '" style="' +  style + '"/>';
    }
    else {
        content += '<img src="' + filename + '" style="' +  style + '"/>';
    }

    content += '<br/>';

    style = "text-align: center;"
    if (item.published) {
        style += "font-weight: bold;";
        content += '<span style="' + style + '">' + avg + '</span>';
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