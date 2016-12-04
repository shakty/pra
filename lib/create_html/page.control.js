window.onload = function() {
    var curSel, curSelElem;
    var containers;
    function sel(selection, elem) {
        var i, len, containers, container, img;
        if (selection === curSel) return;

        // Change style.
        if (curSelElem) curSelElem.style['font-weight'] = '';
        elem.style['font-weight'] = 'bold';

        // Update selection.
        curSel = selection;
        curSelElem = elem;
        console.log('current selection: ' + curSel);

        // Get image containers.
        if (!containers) {
            containers = document.getElementsByClassName('img-container');
        }

        // Change images display.
        i = -1, len = containers.length;
        for ( ; ++i < len ; ) {
            container = containers[i];
            img = containers[i].children[0];
            if (curSel === 'all') container.style.display = '';
            else if (curSel === 'pub') {
                if (img.className === 'published') container.style.display = '';
                else container.style.display = 'none';
            }
            else {
                if (img.className !== 'published') container.style.display = '';
                else container.style.display = 'none';
            }
        }
    }

    document.getElementById("images_all").onclick = function() {
        sel('all', this);
    };
    document.getElementById("images_pub").onclick = function() { 
        sel('pub', this);
    };
    document.getElementById("images_rej").onclick = function() {
        sel('rej', this);
    };
};