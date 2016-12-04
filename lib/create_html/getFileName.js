module.exports = function getFileName(item) {
    return '../faces/' + item.group + '_' + item.treatment + '_' 
        + item.player + '_' + item.round + '.png';
};
