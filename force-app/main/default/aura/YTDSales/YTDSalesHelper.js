({
    setStatus: function(cmp, helper, val) {
        console.log(val);
        var status;
        if(val > 10) {
            status = 'success';
        } else if (val > -10) {
            status = 'warning';
        } else {
            status = 'error';
        }
        cmp.set('v.status', status);
    }
})