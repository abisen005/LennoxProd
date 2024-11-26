({
    handleInit: function handleInit(cmp, evt, h) {
        console.log('Init');
        var pageReference = cmp.get("v.pageReference");
        
        h.getCoachingInfo(cmp);
        if(pageReference!=null && pageReference.state.c__id != null){
            console.log('SC_Containeer hjgkadfa,gh ',pageReference.state.c__id);
            cmp.set('v.CoachingSessionId', pageReference.state.c__id);
            cmp.set('v.redirect', 'true');
            console.log('111',cmp.find('test'));
            //setTimeout(function(){console.log('2222',cmp.find('test')); cmp.find('test').click(); }, 3000);
            var routeChangeEvent = $A.get('e.c:routeChangeAttempt'),
                to ='/session/'+pageReference.state.c__id,
                label ='Session',
                routerName = to.indexOf('/') > 0 ? to.split('/')[0] : '';
            console.log(routerName, to, label);
            routeChangeEvent.setParams({ routerName: routerName, path: to, label: label });
            routeChangeEvent.fire(); 
        }
    },
    handleCoachingInfoRequest: function handleCoachingInfoRequest(cmp, evt, h) {
        //check if it is populated yet.. if so, fire event, if not, wait and try again
        var coachingInfo = cmp.get('v.coachingInfo');
        console.log('handleCoachingInfoRequest');
        
        if(evt.getParam('isRefresh')){
            console.log('isRefresh');
            h.sendRefreshedCoachingInfo(cmp, evt, h);
        }else{
            console.log('coachingInfo');
            h.sendCoachingInfo(coachingInfo);
        }
    },
    handleStartNewCoachingSession: function handleStartNewCoachingSession(cmp, evt, h) {
        console.log('evt.getParams ', evt.getParams());
        h.openNewCoachingSession(cmp, evt);
    }
});