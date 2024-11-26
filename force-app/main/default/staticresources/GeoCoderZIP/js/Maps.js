function ToggleSearchDiv() {
		ShowSearch = !ShowSearch;
		HideShowSearchDiv();
} // ToggleSearchDiv

function HideShowSearchDiv() {
		if (ShowSearch == true) {
			j$( "#SearchPanel" ).show( "slow" );
		} else {
			j$( "#SearchPanel" ).hide( "slow" );
		}

		j$('#chkSearch').prop('checked', ShowSearch);
		j$('#chkSearch').button("refresh");
		
} // HideShowSearchDiv

function toggleHeatmap() {		
	heatmap.setMap(ShowHeatMap ? null : map);
	ToggleHeatMapSettingsDiv();
}	// toggleHeatmap

function ToggleHeatMapSettingsDiv() {
		
		if (ShowHeatMap == false) {		
			changeOpacity();
			changeRadius();
			j$( "#HeatMapSettingsPanel" ).show( "slow" );
			ShowHeatMap = true;
			j$('#chkHeatmap').prop('checked', true);
			j$('#chkHeatmap').button("refresh");
			
		} else {
			j$( "#HeatMapSettingsPanel" ).hide( "slow" );
			ShowHeatMap = false;
			j$('#chkHeatmap').prop('checked', false);
			j$('#chkHeatmap').button("refresh");
			
		}  // ShowHeatMap == false
	
} // ToggleHeatMapSettingsDiv

function changeRadius() {
 HMRadius = heatmap.get('radius');
 
 j$( "#RadiusPanel" ).slider(
	{
		animate: "fast",
		range: "min",
		min: 0,
		max: 200,
		value: HMRadius,
		slide: function( event, ui ) {
				heatmap.set('radius', j$( "#RadiusPanel" ).slider( "value" ));
			}								  		 
	}
  );	
			  
} // changeRadius

function changeOpacity() {
	 HMOpacity = parseFloat(heatmap.get('opacity'));
	 
	 j$( "#OpacityPanel" ).slider(
		{
			animate: "fast",
			range: "min",
			min: 0,
			max: 1,
			step: 0.1,
			value: HMOpacity,
			slide: function( event, ui ) {
					heatmap.set('opacity', j$( "#OpacityPanel" ).slider( "value" ));
				}								  		 
		}
	  );	
} // changeOpacity

function hideMarkers() {
	if (ShowMarkerClusters == false) {
		for (var i = 0; i < MarkersArray.length; i++) {
			MarkersArray[i].setMap(null);
		}
		ShowMarkers = false;
	}
} // hideMarkers

function showMarkers() {
	if (ShowMarkerClusters == false) {
		for (var i = 0; i < MarkersArray.length; i++) {
			MarkersArray[i].setMap(map);
		}
		ShowMarkers = true;	
		j$('#chkMarkers').prop('checked', true);
		j$('#chkMarkers').button("refresh");
		
	}
} // showMarkers

function toggleClusters() {
	
	var mcOptions = {gridSize: 40, maxZoom: 9};
	
	if (!typeof markerclusterer === "undefined") {
		markerclusterer.clearMarkers();
	}
	
	if (ShowMarkerClusters == false) {						
		markerclusterer = new MarkerClusterer(map, MarkersArray, mcOptions);
		ShowMarkerClusters = true;
		ShowMarkers = true;
		j$('#chkMarkers').prop('checked', true);
		j$('#chkMarkers').button("refresh");
	} else {							
		
		// cache the original state because hide method will change.
		var OGShowMarkers = ShowMarkers;
		
		markerclusterer.resetViewport();
		
		ShowMarkerClusters = false;
		hideMarkers();
		
		if(OGShowMarkers == true) {			
			showMarkers();
		}		
		
	} // ShowMarkerClusters = false
	
} // toggleClusters		

function toggleMarkers() {
	ShowMarkers ? hideMarkers() : showMarkers();
} // toggleMarkers

function AccountInformation(Name,Lat,Long,Desc) {
	this.Name = Name;
	this.Lat = Lat;
	this.Long = Long;
	this.Desc = Desc;
} // AccountInformation

function addPopUpWindow(marker, message) {
	var infowindow = new google.maps.InfoWindow({
		content: '<div style="line-height:1.35;overflow:hidden;white-space:nowrap;">' + message + '</div>'
	  });
	
	  google.maps.event.addListener(marker, 'click', function() {
		infowindow.open(marker.get('map'), marker);
	  });

} // addPopUpWindow
