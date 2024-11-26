({
	handleInit: function handleInit(cmp, evt, h) {
		cmp.set('v.isLoading', true);
		h.getUser(cmp);
		h.getPlanningHistory(cmp);
		h.getPlanning(cmp);
		setTimeout($A.getCallback(function () {
			h.requestCoachingInfo();
		}), 1000);
	},
	handleCreatePlanningPress: function handleCreatePlanningPress(cmp, evt, h) {
		cmp.set('v.isLoading', true);
		var nameVal = evt.srcElement.name,
		    dt = new Date(),
		    year = nameVal === 'thisYear' ? dt.getFullYear() : dt.getFullYear() + 1;
		h.newPlanning(cmp, year);
	},
	handleMenuSelect: function handleMenuSelect(cmp, evt, h) {
		//in spring 17 update, should be evt.getSource().get('v.value')
		var planningId = evt.detail.menuItem.get('v.value'),
		    plans = cmp.get('v.plans');
		plans.forEach(function (plan) {
			plan.isSelected = plan.planningId === planningId;
		});
		cmp.set('v.isLoading', true);
		cmp.set('v.plans', plans);
		h.getPlanning(cmp, planningId);
	},
	handleCoachingInfoResponse: function handleCoachingInfoResponse(cmp, e, h) {
		var coachingInfo = e.getParam('coachingInfo');
		if (coachingInfo == null) {
			window.setTimeout($A.getCallback(function () {
				h.requestCoachingInfo();
			}), 1000);
		} else {
			cmp.set('v.coachingInfo', coachingInfo);
			cmp.set('v.showPlanningTopics', true);
		}
	}
});