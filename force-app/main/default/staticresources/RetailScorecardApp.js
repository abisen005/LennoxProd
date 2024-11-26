var retailScorecardApp = (function(w) {

    //private vars
    var p = {}, //public object returned by module
        printFunctions = []; //functions in this list will be invoked before printing

    //private functions
    /**
    * Iterate through and execute functions in printFunctions list
    */
    var executePrintFunctions = function() {
        for(var i = 0, x = printFunctions.length; i < x; i++) {
            printFunctions[i].call();
            console.log('executed ', printFunctions[i]);
        }
    };


    /**
    * Change the display property of elements matching the querySelectorValue
    */
    function changeDisplayPoperty(querySelectorValue, displayProperty) {
        var els = document.querySelectorAll(querySelectorValue);
        for(var i = 0; i < els.length; i++) {
            els[i].style.display = displayProperty;
        }
    }


    /**
    * Execute before print functions (redraw app charts) and invoke window.print;
    */
    p.redrawAndPrint = function() {
        executePrintFunctions();
        p.makeColumnHeightSame(105);
        //w.print();
        w.setTimeout(function() {
            p.makeColumnHeightSame();
        }, 3000);
    };

    /**
    * Make the grand children of all elements with the class 'even-col-height' the same height
    */
    p.makeColumnHeightSame = function(reduceHeightAmount) {
        console.log(reduceHeightAmount);
        reduceHeightAmount = reduceHeightAmount || 0;
        console.log(reduceHeightAmount);
        var rows = document.querySelectorAll('.js-even-col-height'),
        col,
        highestCol = 0,
        i, x;
        for(i = 0; i < rows.length; i++) {
            for(x = 0; x < rows[i].children.length; x++) {
                col = rows[i].children[x];
                col.children[0].style.height = 'auto';
                highestCol = col.offsetHeight > highestCol ? col.offsetHeight : highestCol;
            }
            for(x = 0; x < rows[i].children.length; x++) {
                rows[i].children[x].children[0].style.height = (highestCol - ( i === 1 ? reduceHeightAmount + reduceHeightAmount : reduceHeightAmount)) + 'px';
            }
        }
    };

    /**
    * Add function to printFunctions list.
    * @param  {function} fn
    */
    p.addBeforePrintFunction = function(fn) {
        printFunctions.push(fn);
    };


    p.handleDealerViewClick = function() {
        changeDisplayPoperty('.js-hide-dealer-view', 'none');
        changeDisplayPoperty('#js-dealer-view', 'none');
        changeDisplayPoperty('#js-internal-view', 'inline-block');
    };

    p.handleInternalViewClick = function() {
        changeDisplayPoperty('.js-hide-dealer-view', 'block');
        changeDisplayPoperty('#js-dealer-view', 'inline-block');
        changeDisplayPoperty('#js-internal-view', 'none');
    };


    return p;

}(window));

window.onload = function() {
    retailScorecardApp.makeColumnHeightSame();
    onBeforePrint = retailScorecardApp.redrawAndPrint;
};
window.onresize = function() {
    retailScorecardApp.makeColumnHeightSame();
};

document.getElementById('js-dealer-view').addEventListener(
    'click',
    retailScorecardApp.handleDealerViewClick,
    false
);

document.getElementById('js-internal-view').addEventListener(
    'click',
    retailScorecardApp.handleInternalViewClick,
    false
);
