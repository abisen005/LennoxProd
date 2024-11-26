var rateChart = function(config, el) {

    var DEFAULT_BAR_HEIGHT = 20,
        PRINT_BAR_HEIGHT = 15,
        MIN_HEIGHT = 200,
        PRINT_MIN_HEIGHT = 160;
    
    config.colors = ['#C25454', '#53C253'];
    config.minHeight = config.printing ? PRINT_MIN_HEIGHT : MIN_HEIGHT;
    config.barHeight = config.printing ? PRINT_BAR_HEIGHT : DEFAULT_BAR_HEIGHT;
    if(!config.width) {
        config.width = d3.select(el).node().getBoundingClientRect().width;
    }
    config.height = config.barHeight * config.data.length + (config.data.length * 5) < config.minHeight ? config.minHeight : config.barHeight * config.data.length + (config.data.length * 5) + 60;
    
    //x scale is 200% - 100% on left side, 100% on right side
    var x = d3.scale.ordinal().domain([0, 2])
    .rangeRoundBands([0, config.width]);
    
    var chart = d3.select(el)
    .append('svg')
    .attr('width', config.width)
    .attr('height', config.height);
    
    /*var middleLine = chart.append('line')
        .attr('class', 'middle-line')
        .attr('x1', config.width / 2)
        .attr('y1', config.height)
        .attr('x2', config.width / 2)
        .attr('y2', 0);*/
    
    var rateRectsGroup = chart.selectAll('g.rates')
    .data(config.data).enter()
    .append('g')
    .attr('class', 'rates')
    .attr("transform", function(d, i) { 
        var xPos,
            yPos = (i % 2 === 0 ? i+2 : i+1) * config.barHeight + ((i % 2 === 0 ? i+2 : i+1) * 5);
        xPos = i % 2 === 0 ? config.width / 2 - (config.width * d.rate) / 2 - 1 : config.width / 2 + 1;
        return "translate(" + xPos + "," + yPos + ")"; 
    });
    
    var rateRects = rateRectsGroup.append('rect')
    .attr('height', config.barHeight)
    .attr('width', function(d) {return (config.width * d.rate) / 2})
    .style('fill', function(d, i) { return config.colors[i % 2] });
    
    var rateRectsValuesContainer = rateRectsGroup.append('rect')
    .attr('class', 'rate-value-container')
    .attr('height', config.barHeight - 4)
    .attr('width', 40)
    .attr('rx', 5)
    .attr("transform", function(d, i) { 
        var xPos = (i % 2 === 0 ? (config.width * d.rate) / 2 - 45 : 5),
            yPos = 2;
        return "translate(" + xPos + "," + yPos + ")"; 
    });
    
    var rateRectsValues = rateRectsGroup
    .attr('class', 'rate-value')
    .append('text')
    .attr("transform", function(d, i) { 
        var xPos,
            yPos = (config.barHeight / 2) + 4;
        i % 2 === 0 ? xPos = (config.width * d.rate) / 2 - 10 : xPos = 10;
        return "translate(" + xPos + "," + yPos + ")"; 
    })
    .append('tspan')
    .attr('text-anchor', function(d, i) {return i % 2 === 0 ? 'end' : 'start'})
    .text(function(d) {return d3.format(",.1%")(d.rate)});
    
    var targets = chart.selectAll('line.target')
    .data(config.targets).enter()
    .append('line')
    .attr('class', 'target')
    .attr('x1', function(d, i) {
        if(i === 0) {
            return (config.width / 2) * (1 - d);
        } else {
            return config.width - (config.width / 2) * (1 - d);
        }
    })
    .attr('y1', config.height)
    .attr('x2', function(d, i) {
        if(i === 0) {
            return (config.width / 2) * (1 - d);
        } else {
            return config.width - (config.width / 2) * (1 - d);
        }
    })
    .attr('y2', 0)
    .attr('stroke-dasharray', '8, 4, 2, 4');
    
    var targetText = chart.append('text'),
        targetTextLabels = targetText.selectAll('tspan.target-text')
    .data(config.targets).enter()
    .append('tspan')
    .attr('class', 'target-text')
    .attr('x', function(d, i) { return i === 0 ? 0 : config.width; })
    .attr('y', 0)
    .attr("text-anchor", function(d, i) { return i === 0 ? "start" : "end";})
    .attr('dy', '1.2em')
    .style('fill', function(d, i) {return config.colors[i % 2]})
    .text('Target')
    .append('tspan')
    .attr('class', 'target-text')
    .append('tspan')
    .attr('x', function(d, i) { return i === 0 ? 0 : config.width; })
    .attr('dy', '1.2em')
    .style('fill', function(d, i) {return config.colors[i % 2]})
    .text(function(d, i) {return  d * 100 + '%'});
    
    var rateRectsLabels = chart.selectAll('text.rate-label')
    .data(config.labels)
    .enter()
    .append('text')
    .attr('class', 'rate-label')
    .attr("transform", function(d, i) { 
        var xPos = config.width / 2,
            yPos = config.height - 10;
        xPos += i === 0 ? -15 : 15; 
        return "translate(" + xPos + "," + yPos + ")"; 
    })
    .append('tspan')
    .attr('text-anchor', function(d, i) {return i === 0 ? 'end' : 'start'})
    .style('fill', function(d, i) {return config.colors[i % 2]})
    .text(function(d) {return d});
    
    var barText = chart.selectAll('text.bar-text')
    .data(config.data).enter()
    .append('text')
    .attr('class', 'bar-text')
    .attr('text-anchor', 'middle')
    .attr("transform", function(d, i) { 
        var xPos = config.width / 2,
            yPos = (i % 2 === 0 ? i+2 : i+1) * config.barHeight - config.barHeight  + ((i % 2 === 0 ? i+2 : i+1) * 5);
        return "translate(" + xPos + "," + yPos + ")"; 
    })
    .append('tspan')
    .attr('dy', '1.3em')
    .text(function(d) {return d.label});
    
}


