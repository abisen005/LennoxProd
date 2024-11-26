({
    isReadyToBuild: function(cmp) {
        var hasLabel = !$A.util.isUndefinedOrNull(cmp.get('v.label')),
            hasPercentageComplete = !$A.util.isUndefinedOrNull(cmp.get('v.percentageComplete'));
        if(hasLabel && hasPercentageComplete) {
            return true;
        } else {
            return false;
        }
    },
    buildChart: function(cmp, helper) {
        var percentageComplete = cmp.get('v.percentageComplete');
        console.log('percentageComplete',  percentageComplete);
		var chartFillValue = {
            success: '#4BCA81',
            warning: '#FFB75D',
            error: '#c23934'
        };
        var newChart = new donutChart({
            height: 130,
            width: 130,
            label: cmp.get('v.label'),
            labelClass: 'chart-label ' + cmp.get('v.status'),
            subLabel: cmp.get('v.subLabel'),
            subLabelClass: 'chart-sub-label',
            bgColor: '#D8DDE6',
            tweenThickness: false,
            thickness: 7,
            container: '.' + cmp.get('v.class'),
            data: {
                total: 100,
                values: [{
                    n: cmp.get('v.percentageComplete'),
                    color: chartFillValue[cmp.get('v.status')] || '#0070D2'
                }]
            }
        });
	}
})