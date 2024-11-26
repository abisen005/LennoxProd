//build bar rate compare chart function
var buildRateCompareChart = function(config, el) {


    config = setupConfig(config);

    function drawRateRectsGroup(data) {
        data.append('g')
        .attr('class', 'rates')
        .attr("transform", function(d, i) {
            var xPos = config.margin.left,
                yPos = config.mostRecentGroupHeight +  config.margin.top,
                groupHeight = d.data.length * (config.barHeight + config.barMarginBottom) + 60;
            config.mostRecentGroupHeight += groupHeight;
            return "translate(" + xPos + "," + yPos + ")";
        })
        .append('text')
        .attr('class', 'category-label')
        .text(function(d) {
            return d.category
        });
    }

    function setupConfig(config) {
        config.colors = ['#C25454', '#53C253 '];
        config.rateRectsGroupMarginBottom = config.printing ? 10 : 20;
        config.barHeight = config.printing ? 20 : 40;
        config.barMarginBottom = config.printing ? 15 : 25;
        config.margin = {
            top: 10,
            right: 10,
            bottom: 20,
            left: 0
        };
        config.mostRecentGroupHeight = 0;
        config.width = config.printing ? 265 : el.clientWidth - config.margin.left - config.margin.right;

        config.height = 0;
        config.data.forEach(function(item) {
            config.height += item.data.length * (config.barHeight + config.barMarginBottom) + 40;
        })
        return config;
    }

    function drawDataBars(data) {
        data.append('rect')
        .attr('height', config.barHeight)
        .attr('width', function(d) {
            console.log('width', d);
            return config.width * d.value;
        })
        .classed('success', function(d) {
            return d.value >= config.target;
        })
        .classed('error', function(d) {
            return d.value < config.target;
        });
    }

    function drawDataBarLabels(data) {
        data.append('text')
        .attr('class', 'rate-label')
        .append('tspan')
        .attr('dy', '-0.3em')
        .text(function(d) {
            return d.label;
        });
    }

    function drawDataBarValues(data) {
        data.append('rect')
        .attr('class', 'rate-value-container')
        .attr('height', config.barHeight - 8)
        .attr('width', 36)
        .attr('rx', 5)
        .attr("transform", function(d, i) {
            var xPos = (config.width * d.value) / 2 - 18,
                yPos = 4;
            return "translate(" + xPos + "," + yPos + ")";
        });
        data.append('text')
        .attr('class', 'rate-value')
        .attr('text-anchor', 'middle')
        .attr("transform", function(d, i) {
            var xPos = ((config.width * d.value) / 2),
                yPos = (config.barHeight / 2) + 4;
            return "translate(" + xPos + "," + yPos + ")";
        })
        .append('tspan')
        .text(function(d) { return d3.format(",.1%")(d.value); });
    }

    function drawTarget(target) {
        var container = d3.select(el).select('svg'),
            targetGroup = container.append('g').attr('class', 'target-group'),
            targetText = targetGroup.append('text'),
            xVal = config.width * target,
            targetOffset = target > .5 ? -3 : 3,
            textAnchor = target > .5 ? 'end' : 'start';

        targetGroup.append('line')
        .attr('class', 'target')
        .attr('x1', xVal)
        .attr('y1', config.height)
        .attr('x2', xVal)
        .attr('y2', 0)
        .attr('stroke-dasharray', '8, 4, 2, 4');
        targetText.append('tspan')
        .attr('class', 'target-text')
        .attr('x', xVal + targetOffset)
        .attr('y', 0)
        .attr('dy', '1.2em')
        .attr('text-anchor', textAnchor)
        .text('Target')
        targetText.append('tspan')
        .attr('class', 'target-text')
        .attr('x', xVal + targetOffset)
        .attr('dy', '1.2em')
        .attr('text-anchor', textAnchor)
        .text(function() {return  target * 100 + '%'});
    }

    function drawRateRectsBars(rateRectsGroup) {
        var rateRectsBars = rateRectsGroup.selectAll('rect.value')
        .data(function(d) {
            return d.data;
        });

        var barGroup = rateRectsBars.enter().append('g').attr('class', 'bar');
        barGroup.attr('transform', function(d, i) {
            var xPos = 0,
                yPos = (config.barHeight * (i + 1)) + (config.barMarginBottom * i);
            return "translate(" + xPos + "," + yPos + ")";
        });

        drawDataBars(barGroup);
        drawDataBarLabels(barGroup);
        drawDataBarValues(barGroup);
    }

    var chart = d3.select(el)
    .append('svg')
    .attr('width', config.width + config.margin.left + config.margin.right)
    .attr('height', config.height + config.margin.top + config.margin.bottom);

    var rateRectsGroup = chart.selectAll('g.rates')
    .data(config.data, function(d) { return d.category; });

    drawRateRectsGroup(rateRectsGroup.enter());
    drawTarget(config.target);
    rateRectsGroup.exit().remove();
    drawRateRectsBars(rateRectsGroup);

};

var buildBulletChart = function(config, el, bulletChartData) {
    config = config || {};
    var chartContainer = el;
    var childNode = chartContainer.childNodes[0];
    childNode ? chartContainer.removeChild(childNode) : null;
    var data = bulletChartData;
    var container = d3.select(el).node().getBoundingClientRect();
    var margin = config.margin || {top: 20, right: 10, bottom: 40, left: 80},
        width = config.chartWidth || container.width - margin.left - margin.right,
        height = config.chartHeight || 65;
    var chart = d3.bullet(width, height)
    .width(width)
    .height(height);
    var svg = d3.select(el).selectAll("svg")
    .data(data)
    .enter().append("svg")
    .attr("class", "bullet")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
    .call(chart);

    var title = svg.append("g")
    .style("text-anchor", "end")
    .attr("transform", "translate(-6," + height / 2 + ")");

    title.append("text")
    .attr("class", "title")
    .text(function(d) { return d.title; });

    title.append("text")
    .attr("class", "title")
    .attr("dy", "1.2em")
    .text(function(d) { return d.subtitle; });
};


var CCSC = (function() {

    /**
    * Make the grand children of all elements with the class 'even-col-height' the same height
    */
    makeColumnHeightSame = function(reduceHeightAmount) {
        reduceHeightAmount = typeof reduceHeightAmount !== 'undefined' ? reduceHeightAmount : 0;
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

    var selfGenBarChartEl = document.getElementById('selfGenBarChart'),
        periodLeadToInstallRateEl = document.getElementById('periodLeadToInstallRate'),
    	ytdLeadToInstallRateEl = document.getElementById('ytdLeadToInstallRate'),
        perdiodBulletChartEl = document.getElementById('bullet-chart-period'),
        ytdBulletChartEl = document.getElementById('bullet-chart-ytd');

    var clearChartEls = function() {
        if(selfGenBarChartEl.children[0]) selfGenBarChartEl.children[0].remove();
        if(perdiodBulletChartEl.children[0]) perdiodBulletChartEl.children[0].remove();
        if(ytdBulletChartEl.children[0]) ytdBulletChartEl.children[0].remove();
        if(periodLeadToInstallRateEl.children[0]) periodLeadToInstallRateEl.children[0].remove();
        if(ytdLeadToInstallRateEl.children[0]) ytdLeadToInstallRateEl.children[0].remove();
    }

    if(rateCompareChartConfig.data[0].category.indexOf('Region') > 0) {
        rateCompareChartConfig.data.reverse();
    }

    buildRateCompareChart(rateCompareChartConfig, selfGenBarChartEl);


    var periodGauge = gauge(periodLeadToInstallRateEl, periodLeadToInstallRateConfig);
    periodGauge.render();
    periodGauge.update(periodLeadToInstallRateConfig.value);

    var ytdGauge = gauge(ytdLeadToInstallRateEl, ytdLeadToInstallRateConfig);
    ytdGauge.render();
    ytdGauge.update(ytdLeadToInstallRateConfig.value);

    buildBulletChart({}, perdiodBulletChartEl, periodBulletChartData);
    buildBulletChart({}, ytdBulletChartEl, ytdBulletChartData);

	var printReport = function() {
        var GAUGE_CHART_WIDTH = 150
        bodyClass = document.body.className,
            printRateCompareChartConfig = {printing: true},
            printYTDLeadToInstallRateConfig = cloneObj(ytdLeadToInstallRateConfig),
            printPeriodLeadToInstallRateConfig = cloneObj(periodLeadToInstallRateConfig);

        printRateCompareChartConfig = cloneObj(rateCompareChartConfig, printRateCompareChartConfig);
        printYTDLeadToInstallRateConfig.size = GAUGE_CHART_WIDTH;
        printYTDLeadToInstallRateConfig.clipWidth = GAUGE_CHART_WIDTH;
        printYTDLeadToInstallRateConfig.clipHeight = (GAUGE_CHART_WIDTH  / 2) + 15;
        printPeriodLeadToInstallRateConfig.size = GAUGE_CHART_WIDTH;
        printPeriodLeadToInstallRateConfig.clipWidth = GAUGE_CHART_WIDTH;
        printPeriodLeadToInstallRateConfig.clipHeight = (GAUGE_CHART_WIDTH  / 2) + 15;

        console.log('printRateCompareChartConfig ', printRateCompareChartConfig);

        var periodGauge = gauge(periodLeadToInstallRateEl, printPeriodLeadToInstallRateConfig);
        periodGauge.render();
        periodGauge.update(periodLeadToInstallRateConfig.value);

        var ytdGauge = gauge(ytdLeadToInstallRateEl, printYTDLeadToInstallRateConfig);
        ytdGauge.render();
        ytdGauge.update(ytdLeadToInstallRateConfig.value);
        //document.body.style.width = '960px';
        document.body.className = bodyClass + ' print';
        clearChartEls();
        buildRateCompareChart(printRateCompareChartConfig, selfGenBarChartEl);
        periodGauge.update(periodLeadToInstallRateConfig.value);
        ytdGauge.update(ytdLeadToInstallRateConfig.value);
        buildBulletChart({chartWidth: 250, chartHeight: 40, margin: {top: 10, right: 8, bottom: 20, left: 84}}, perdiodBulletChartEl, periodBulletChartData);
        buildBulletChart({chartWidth: 250, chartHeight: 40, margin: {top: 10, right: 8, bottom: 20, left: 84}}, ytdBulletChartEl, ytdBulletChartData);
        var rows = document.querySelectorAll('.js-even-col-height');
        for(i = 0; i < rows.length; i++) {
            for(x = 0; x < rows[i].children.length; x++) {
                var firstRow = i === 0,
                    secondRow = i === 1;
                rows[i].children[x].children[0].style.height = firstRow ? '265px' : '265px';
            }
        }
        /*window.print();
        document.body.style.width = 'auto';
        document.body.className = bodyClass;
        clearChartEls();
        buildRateCompareChart(rateCompareChartConfig, selfGenBarChartEl);
        periodGauge.update(periodLeadToInstallRateConfig.value);
        ytdGauge.update(ytdLeadToInstallRateConfig.value);
        buildBulletChart(perdiodBulletChartEl.clientWidth, perdiodBulletChartEl, periodBulletChartData);
        buildBulletChart(ytdBulletChartEl.clientWidth, ytdBulletChartEl, ytdBulletChartData);
        makeColumnHeightSame();*/

        function cloneObj(origConfig, newObj) {
            var clonedObj = newObj || {};
            origConfig = origConfig || {};
            for(prop in origConfig) {
                clonedObj[prop] = origConfig[prop];
            }
            return clonedObj;
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

    function handleDealerViewClick() {
        changeDisplayPoperty('.js-hide-dealer-view', 'none');
        changeDisplayPoperty('#js-dealer-view', 'none');
        changeDisplayPoperty('#js-internal-view', 'inline-block');
    };

    function handleInternalViewClick() {
        changeDisplayPoperty('.js-hide-dealer-view', 'block');
        changeDisplayPoperty('#js-dealer-view', 'inline-block');
        changeDisplayPoperty('#js-internal-view', 'none');
    };

    onBeforePrint = printReport;

    window.onload = function() {
        makeColumnHeightSame();
    };
    window.onresize = function() {
        makeColumnHeightSame();
    };

    document.getElementById('js-dealer-view').addEventListener(
        'click',
        handleDealerViewClick,
        false
    );

    document.getElementById('js-internal-view').addEventListener(
        'click',
        handleInternalViewClick,
        false
    );


}());
