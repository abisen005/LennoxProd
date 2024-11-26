({
    handleAfterScriptsLoaded: function(cmp, event, helper) {
        cmp.set('v.scriptsReady', true);
        if(helper.isReadyToBuild(cmp)) {
            helper.buildChart(cmp, helper);
        }
    },
    
    handleChartChange: function(cmp, event, helper) {
        var el,
            elContents,
        	scriptsReady = cmp.get('v.scriptsReady');
        
        if(helper.isReadyToBuild(cmp) 
           && scriptsReady 
           && cmp.get('v.class')) {
            el = document.getElementsByClassName(cmp.get('v.class'))[0];
            
            if(el) {
                elContents = el.children[0];
                
                if(elContents){
                    elContents.remove();
                }
            }
            
            helper.buildChart(cmp, helper);
        }
    }
})