angular.module('map', ['ngAnimate', 'ngTouch', 'ui.bootstrap'])

.directive('toggleSlideRight', [function() {
    return{
        restrict: 'A',
        scope: {
            toggleSlideRight: '='
        },
        link: function(scope, element, attrs, controller){
            scope.$watch('toggleSlideRight', function(newValue) {
                if(!newValue) {
                    $(element).velocity(
                        { translateX: '103%' },
                        {
                            display: 'none',
                            duration: 250,
                            easing: [500, 50]
                        }
                    );
                } else {
                    $(element).velocity(
                        {translateX: '0%'},
                        {
                            display: 'auto',
                            duration: 250,
                            easing: [500, 50]
                        }
                    );
                }
            });
        }
    }
}])

.service('context', function($timeout) {
    this.getMode = function() {
        if(currentUser.role.indexOf('Res Territory') != -1) {
            return 'TM';
        } else if(currentUser.role.indexOf('Res District Manager') != -1 || currentUser.role.indexOf('Res Area Sales Manager') != -1 || currentUser.role.indexOf('Res LPP SM') != -1 || currentUser.role.indexOf('Res Inside Sales') != -1) {
            return 'DM';
        } else {
            return 'Global';
        }
    };
    this.getDefaultFilters = function() {
        if(currentUser.role.indexOf('Res LPP SM') != -1) {
            return ['ha', 'ca', 'lpp'];
        } else {
            return ['pd', 'sd', 'aod', 'sp', 'aop'];
        }
    }
    this.isSalesforceOne = function() {
        var ua = ' ' + navigator.userAgent;
        
        if(ua.includes('SalesforceMobileSDK')) {
            
            return true;
        } else {
            return false;
        }
    }
    this.disableAutoSearch = function() {
        var self = this;
        self.noAutoSearch = true;
        $timeout(function() {
            self.noAutoSearch = false;
        }, 2000);
    }
    this.mode = this.getMode();
    this.defaultFilters = this.getDefaultFilters();
    this.sforceone = this.isSalesforceOne();
    this.noAutoSearch = false;

    // FILTER_BY_DEALER or LPP_STORE
    // Filter by dealer indicates user is using standard filters
    // LPP Store indicates user is searching by a specific LPP Store
    var searchType = 'FILTER_BY_DEALER';
    this.setSearchType = function(newSearchType) {
        searchType = newSearchType;
    };
    this.getSearchType = function() {
        return searchType;
    };

    // If searching by LPP Store, this var holds the account id of the LPP Store
    var lppStoreId = '';
    this.setLPPStoreId = function(accountId) {
        lppStoreId = accountId;
    };
    this.getLPPStoreId = function() {
        return lppStoreId;
    };

    // maintain furthest SW coordinates and furthest NE coordinates to
    // allow for panning out after results are done
    var southWestLatLon = [];
    var northEastLatLon = [];

    this.setMaxCoordinates = function(data) {
        var isCoordinatesSet = southWestLatLon[0],
            minLat,
            minLon,
            maxLat,
            maxLon;
        console.log('isCoordinatesSet ', southWestLatLon, isCoordinatesSet);
        if(isCoordinatesSet) {
            console.log('coordinates already set, make sure to set min/max values');
            minLat = southWestLatLon[0];
            minLon = southWestLatLon[1];
            maxLat = northEastLatLon[0];
            maxLon = northEastLatLon[1];
        }
        for(var i = 0; i < data.length; i++) {
            var lat = data[i].geometry.coordinates[1],
                lon = data[i].geometry.coordinates[0];
            if(i === 0 && !isCoordinatesSet) {
                console.log('coordinates arent set; set min/max values to first item in list');
                minLat = lat;
                minLon = lon;
                maxLat = lat;
                maxLon = lon;
            }
            if(lat < minLat) minLat = lat;
            if(lon < minLon) minLon = lon;
            if(lat > maxLat) maxLat = lat;
            if(lon > maxLon) maxLon = lon;
        }
        southWestLatLon = [minLat, minLon];
        northEastLatLon = [maxLat, maxLon];
        console.log({
            southWestLatLon: southWestLatLon,
            northEastLatLon: northEastLatLon
        });
    };

    this.resetMaxCoordinates = function() {
        southWestLatLon = [];
        northEastLatLon = [];
    };

    this.getMaxCoordinates = function() {
        return {
            southWestLatLon: southWestLatLon,
            northEastLatLon: northEastLatLon
        };
    };


})

.service('mapFilters', function(context) {

    var salesFieldFilters = {
        filterField: '',
        filterMin: 0,
        filterMax: 0,
        useSalesFilter: false
    };

    this.getSalesFieldFilters = function() {
        return salesFieldFilters;
    };

    this.setSalesFieldFilters = function(filterField, filterMin, filterMax, useSalesFilter) {
        salesFieldFilters.filterField = filterField;
        salesFieldFilters.filterMin = filterMin;
        salesFieldFilters.filterMax = filterMax;
        salesFieldFilters.useSalesFilter = useSalesFilter;
    };

    this.resetSalesFieldFilters = function() {
        this.setSalesFieldFilters('', 0, 0, false);
    }.bind(this);


    this.getSelectedFilters = function(dealerSelection) {
        var selectedFilters = [],
            findSelectedFilters = function(obj) {
                for(prop in obj) {
                    if(obj[prop].active) {
                        selectedFilters.push(obj[prop].id);
                    }
                }
            };
        if(dealerSelection == 'type') {
            findSelectedFilters(this.filters.otherAccounts.options);
            findSelectedFilters(this.filters.dealers.options);
            findSelectedFilters(this.filters.prospects.options);
            findSelectedFilters(this.filters.retailAccounts.options);
        } else {
            findSelectedFilters(this.attributeFilters);
        }
        return selectedFilters;
    }
    this.getSelectedTerritories = function() {
        var selectedTerritories = [];
        if(context.mode == 'TM') {
            selectedTerritories.push(currentUser.id);
        } else if (this.dealerSelection == 'type') {
            angular.forEach(this.territories, function(value, key) {
                if(value.selected) {
                    selectedTerritories.push(value.userId);
                }
            })
        } else { //dealerSelection is attribute, use all TMs
            angular.forEach(this.territories, function(value, key) {
                selectedTerritories.push(value.userId);
            })
        }
        return selectedTerritories;
    }
    this.territories = [];
    this.dealerSelection = 'type';
    this.showRedoSearchOnMapChange = false;
    this.showRedoSearch = false;
    this.filters = {
        dealers: {
            checkAll: context.defaultFilters.indexOf('pd') == -1 ? true : false,
            optionsVisible: true,
            options: [
                {
                    name : 'Premier',
                    active: context.defaultFilters.indexOf('pd') == -1 ? false : true,
                    icon: iconUrls.pd,
                    id: 'pd'
                },
                {
                    name : 'Strategic',
                    active: context.defaultFilters.indexOf('sd') == -1 ? false : true,
                    icon: iconUrls.sd,
                    id: 'sd'

                },
                {
                    name : 'All Other',
                    active: context.defaultFilters.indexOf('aod') == -1 ? false : true,
                    icon: iconUrls.aod,
                    id: 'aod'
                }
            ]
        },
        prospects: {
            checkAll: context.defaultFilters.indexOf('sp') == -1 ? true : false,
            optionsVisible: true,
            options: [
                {
                    name: 'Strategic',
                    active: context.defaultFilters.indexOf('sp') == -1 ? false : true,
                    icon: iconUrls.sp,
                    id: 'sp'
                },
                {
                    name: 'All Other',
                    active: context.defaultFilters.indexOf('aop') == -1 ? false : true,
                    icon: iconUrls.aop,
                    id: 'aop'
                }
            ]
        },
        otherAccounts: {
            checkAll: context.defaultFilters.indexOf('ca') == -1 ? true : false,
            optionsVisible: true,
            options: [
                {
                    name: 'Cash Accounts',
                    active: context.defaultFilters.indexOf('ca') == -1 ? false : true,
                    icon: iconUrls.ca,
                    id: 'ca'
                },
                {
                    name: 'House Accounts',
                    active: context.defaultFilters.indexOf('ha') == -1 ? false : true,
                    icon: iconUrls.ha,
                    id: 'ha'
                },
                {
                    name: 'Commercial Accounts',
                    active: context.defaultFilters.indexOf('cma') == -1 ? false : true,
                    icon: iconUrls.cma,
                    id: 'cma'
                }
            ]
        },
        retailAccounts: {
            checkAll: context.defaultFilters.indexOf('lws') == -1 ? true : false,
            optionsVisible: true,
            options: [
                {
                    name: 'Lennox Stores',
                    active: context.defaultFilters.indexOf('lpp') == -1 ? false : true,
                    icon: iconUrls.lppLegend,
                    id: 'lpp'
                },
                {
                    name: 'Lowe\'s',
                    active: context.defaultFilters.indexOf('lws') == -1 ? false : true,
                    icon: iconUrls.lwsLegend,
                    id: 'lws'
                },
                {
                    name: 'Home Depot',
                    active: context.defaultFilters.indexOf('hd') == -1 ? false : true,
                    icon: iconUrls.hdLegend,
                    id: 'hd'
                },
                {
                    name: 'Costco',
                    active: context.defaultFilters.indexOf('cc') == -1 ? false : true,
                    icon: iconUrls.ccLegend,
                    id: 'cc'
                }
            ]
        }
    }
    this.attributeFilters = [
        {
            label: 'New Customer Program',
            active: false,
            id: 'nc'
        },
        {
            label: 'NC Program - Eligible',
            active: false,
            id: 'nce'
        },
        {
            label: 'Premier Parts Dealer',
            active: false,
            id: 'npp'
        },{
            label: 'Costco Dealer',
            active: false,
            id: 'cstdr'
        },
        {
            label: "Lowe's Dealer",
            active: false,
            id: 'lwdr'
        },
        {
            label: 'Home Depot Dealer',
            active: false,
            id: 'hdr'
        }
    ]
})

.service('mapbox', function() {

    var featureLayers = [];

    this.addFeatureLayer = addFeatureLayer;
    this.clearFeatureLayers = clearFeatureLayers;

    function addFeatureLayer(featureLayer) {
        featureLayers.push(featureLayer);
    }

    function clearFeatureLayers() {
        featureLayers.forEach(function(layer) {
            layer.clearLayers();
        })
        featureLayers = [];
    }

    L.mapbox.accessToken = 'pk.eyJ1IjoiZ3JlZ2xvdmVsaWRnZTg1IiwiYSI6IlVIcm9qM2sifQ.e7iTHJ1dCyeBgcSFewIvzQ';
    this.map = L.mapbox.map('map', 'greglovelidge85.i296091b', {
        maxBounds: L.latLngBounds(L.latLng(-15.054627, -173.14453), L.latLng(74.91371, 25.26171))
    }).addLayer(L.mapbox.styleLayer('mapbox://styles/mapbox/streets-v11'));
    
    
    
    this.geocoder = L.mapbox.geocoder('mapbox.places');

    this.layers = {};
    this.icoPremierAcc = L.icon({
        iconUrl: iconUrls.pd,
        iconSize: [21, 20],
        popupAnchor: [0, -15]
    });
    this.icoStrategicAcc = L.icon({
        iconUrl: iconUrls.sd,
        iconSize: [21, 20],
        popupAnchor: [0, -15]
    });
    this.icoOtherAcc = L.icon({
        iconUrl: iconUrls.aod,
        iconSize: [21, 20],
        popupAnchor: [0, -15]
    });
    this.icoStategicProspect = L.icon({
        iconUrl: iconUrls.sp,
        iconSize: [21, 20],
        popupAnchor: [0, -15]
    });
    this.icoOtherProspect = L.icon({
        iconUrl: iconUrls.aop,
        iconSize: [21, 20],
        popupAnchor: [0, -15]
    });
    this.icoCashAccount = L.icon({
        iconUrl: iconUrls.ca,
        iconSize: [21, 20],
        popupAnchor: [0, -15]
    });
    this.icoHouseAccount = L.icon({
        iconUrl: iconUrls.ha,
        iconSize: [21, 20],
        popupAnchor: [0, -15]
    });
    this.icoCommercialAccount = L.icon({
        iconUrl: iconUrls.cma,
        iconSize: [21, 20],
        popupAnchor: [0, -15]
    });
    this.icoLPPStore = L.icon({
        iconUrl: iconUrls.lpp,
        iconSize: [65, 30],
        popupAnchor: [0, -15]
    });
    this.icoLowes = L.icon({
        iconUrl: iconUrls.lws,
        iconSize: [48, 30],
        popupAnchor: [0, -15]
    });
    this.icoHD = L.icon({
        iconUrl: iconUrls.hd,
        iconSize: [25, 33],
        popupAnchor: [0, -15]
    });
    this.icoCostco = L.icon({
        iconUrl: iconUrls.cc,
        iconSize: [55, 23],
        popupAnchor: [0, -15]
    });
})

.factory('localMethods', function(mapbox) {
    return {
        //returns bounds distance in meters
        getDistance: function() {
            var bounds = mapbox.map.getBounds(),
                distance = mapbox.map.getCenter().distanceTo(bounds._southWest);
            return distance / 1000;
        },
        getCenter: function() {
            var latLng = mapbox.map.getCenter(),
                location = [];
            location.push(latLng.lat);
            location.push(latLng.lng);
            return location;
        },
        setView: function(lat, lon, zoom) {
            mapbox.map.setView([lat, lon], zoom);
        },
        showMap: function(err, data) {
            if(data.lbounds) {
                mapbox.map.fitBounds(data.lbounds);
            } else {
                this.setView(data.latlng[0], data.latlng[1], 13);
            }
        },
        placeMarker: function(place, latlng) {
            if(typeof mapbox.layers.searchMarkers !== 'undefined') {
             	mapbox.map.removeLayer(mapbox.layers.searchMarkers);
            }
            var marker = {
                type: 'Feature',
                geometry: {
                    type: 'Point',
                    coordinates: [
                        latlng[1],
                        latlng[0]
                    ]
                }
            };
            mapbox.layers.searchMarkers = L.geoJson(marker)
            .addTo(mapbox.map);
        },
        geocode: function(place, zoom, showMarker) {
            var self = this;
            if(zoom) {
                mapbox.geocoder.query(place, function(err, data) {
                    mapbox.map.setView(data.latlng, zoom);
                })
            } else {
                mapbox.geocoder.query(place, function(err, data) {
                    self.showMap(err, data);
                    if(showMarker) {
                        self.placeMarker(place, data.latlng);
                    }
                });
            }
        }
    }
})

.factory('remoteMethods', function($rootScope, $timeout, localMethods, mapbox, context, mapFilters) {
    return {
        getAccounts: function(fieldFilters) {
            console.log('GET ACCOUNTS INVOKED');
            context.resetMaxCoordinates();
            var territories = mapFilters.getSelectedTerritories(),
                types = mapFilters.getSelectedFilters(mapFilters.dealerSelection),
            	iterations = types.length,
                center = localMethods.getCenter(),
                distance = localMethods.getDistance(),
                i = 0,
                offset = 0,
                tmId = territories.length == 0 ? mapFilters.territories[0].userId : null,
                salesFieldFilters = mapFilters.getSalesFieldFilters(),
                filterOptions = [salesFieldFilters.useSalesFilter, salesFieldFilters.filterField, salesFieldFilters.filterMin, salesFieldFilters.filterMax];
            // if npp (Premier Parts Dealers) filter is selected, always get lpp dealers as well
            if(types.indexOf('npp') > -1) types.push('lpp');
            var timeout = window.setTimeout(
                    function() {
                        $rootScope.$broadcast('remoteGetAccounts-complete');
                        $rootScope.$broadcast('error', {'result' : 'Your request timed out. You may need to submit your search again to see all of the results.'});
                    },
                    30000
                );
            var remoteGetAccounts = function(offset) {
                    $rootScope.$broadcast('start-map-loading', {'mapLoadingContent' : 'Loading Accounts...'});
                    Visualforce.remoting.Manager.invokeAction(
                        'MapToolController.getAccounts',
                        territories,
                        types[i],
                        types,
                        center,
                        distance,
                        offset,
                        tmId,
                        filterOptions,
                        function(result, event){
                            if (event.status) {
                                var layerName = types[i] + offset.toString();
                                // This determines the furthest lat/lon values in order to pan out and show
                                // all data on the map. Commented out until it's used later
                                // context.setMaxCoordinates(result);
                                if(types[i] == 'pd') {
                                    setupResult(layerName, mapbox.icoPremierAcc, result);
                                } else if (types[i] == 'sd') {
                                    setupResult(layerName, mapbox.icoStrategicAcc, result);
                                } else if (types[i] == 'aod') {
                                    setupResult(layerName, mapbox.icoOtherAcc, result);
                                } else if (types[i] == 'sp') {
                                    setupResult(layerName, mapbox.icoStategicProspect, result);
                                } else if (types[i] == 'aop') {
                                    setupResult(layerName, mapbox.icoOtherProspect, result);
                                } else if (types[i] == 'ha') {
                                    setupResult(layerName, mapbox.icoHouseAccount, result);
                                } else if (types[i] == 'ca') {
                                    setupResult(layerName, mapbox.icoCashAccount, result);
                                } else if (types[i] == 'cma') {
                                    setupResult(layerName, mapbox.icoCommercialAccount, result);
                                } else if (types[i] == 'lpp') {
                                    setupResult(layerName, mapbox.icoLPPStore, result);
                                } else if (types[i] == 'cc') {
                                    setupResult(layerName, mapbox.icoCostco, result);
                                } else if (types[i] == 'hd') {
                                    setupResult(layerName, mapbox.icoHD, result);
                                } else if (types[i] == 'lws') {
                                    setupResult(layerName, mapbox.icoLowes, result);
                                } else if (types[i] == 'nc') {
                                    setupResult(layerName, mapbox.icoOtherAcc, result);
                                } else if (types[i] == 'nce' || types[i] == 'npp') {
                                    var nceProspects = [],
                                        nceDealers = [],
                                        nceHouseAccounts = [],
                                        nceCashAccounts = [];
                                    angular.forEach(result, function(value, key) {
                                        if(value.properties.isCashAccount) {
                                            nceCashAccounts.push(value);
                                        } else if(value.properties.isHouseAccount) {
                                            nceHouseAccounts.push(value)
                                        } else if(value.properties.dealerNumber) {
                                            nceDealers.push(value);
                                        } else {
                                            nceProspects.push(value)
                                        }
                                    })
                                    setupResult(layerName + 'Prospects', mapbox.icoOtherProspect, nceProspects);
                                    setupResult(layerName + 'Dealers', mapbox.icoOtherAcc, nceDealers);
                                    setupResult(layerName + 'HouseAccounts', mapbox.icoHouseAccount, nceHouseAccounts);
                                    setupResult(layerName + 'CashAccounts', mapbox.icoCashAccount, nceCashAccounts);
                                }else if(types[i] == 'cstdr' || types[i] == 'lwdr' || types[i] == 'hdr'){
                                    setupResultNew(layerName, mapbox.icoCostco, result);
                                }
                                if(result.length == 1000) {
                                    if(offset < 1000) {
                                        offset += 1000;
                                        remoteGetAccounts(offset);
                                    } else {
                                        $rootScope.$broadcast('soql-limit-met');
                                    }
                                } else if(i == types.length - 1) {
                                    window.clearTimeout(timeout);
                                    $rootScope.$broadcast('remoteGetAccounts-complete');
                                    // Uncomment when feature to pan out and show all data in view is added
                                    // showAllGeoDataInView();
                                } else {
                                    i++;
                                    offset = 0;
                                    remoteGetAccounts(offset);
                                }
                            } else {
                                window.clearTimeout(timeout);
                                $rootScope.$broadcast('remoteGetAccounts-complete');
                                $rootScope.$broadcast('error', {'result' : event});
                            }
                        }
                    )
                };
            removeMapboxLayers();
            if(types.length == 0) {
                var message = 'Please select at least one filter.';
                window.alert(message);
                return;
            } else {
                remoteGetAccounts(0);
            }
        },
        getDistricts: function() {
            Visualforce.remoting.Manager.invokeAction(
                'MapToolController.getDistricts',
                currentUser.region,
                function(result, event) {
                    if(event.status) {
                        $rootScope.$broadcast('districts-returned', {'result' : result});
                    } else {
                        $rootScope.$broadcast('districts-error', {'result' : result});
                    }
                }
            )
        },
        getTerritories: function(district) {
            Visualforce.remoting.Manager.invokeAction(
                'MapToolController.getTerritories',
                district,
                function(result, event) {
                    if(event.status) {
                        mapFilters.territories = result;
                        $rootScope.$broadcast('territories-returned', {'result' : result});
                    } else {
                        $rootScope.$broadcast('territories-error', {'result' : result});
                    }
                }
            )
        },
        getAccountData: function(id, accountType) {
            Visualforce.remoting.Manager.invokeAction(
                'MapToolController.getAccountData',
                id,
                accountType,
                function(result, event) {
                    if(event.status) {
                        $rootScope.$broadcast('account-data-returned', {'result' : result});
                    } else {
                        $rootScope.$broadcast('account-data-error', {'result' : result});
                    }
                }
            )
        },
        saveDefaultLocation: function(lat, lon, zoom) {
            Visualforce.remoting.Manager.invokeAction(
                'MapToolController.saveDefaultLocation',
                lat.toString(),
                lon.toString(),
                zoom.toString(),
                currentUser.id,
                function(result, event) {
                    if(event.status) {
                        $rootScope.$broadcast('default-location-saved', {'result' : result});
                    } else {
                        $rootScope.$broadcast('default-location-error', {'result' : result});
                    }
                }
            )
        },
        getSMADealers: function(lppStoreId) {
            $rootScope.$broadcast('start-map-loading', {'mapLoadingContent' : 'Loading Accounts...'});
            context.resetMaxCoordinates();
            var salesFieldFilters = mapFilters.getSalesFieldFilters(),
                center = localMethods.getCenter(),
                distance = localMethods.getDistance();
            var timeout = window.setTimeout(
                    function() {
                        $rootScope.$broadcast('remoteGetAccounts-complete');
                        $rootScope.$broadcast('error', {'result' : 'Your request timed out. You may need to submit your search again to see all of the results.'});
                    },
                    30000
                );
            Visualforce.remoting.Manager.invokeAction(
                'MapToolController.getSMADealers',
                lppStoreId,
                center,
                distance,
                [salesFieldFilters.useSalesFilter, salesFieldFilters.filterField, salesFieldFilters.filterMin, salesFieldFilters.filterMax],
                function(result, event) {
                    removeMapboxLayers();
                    if(event.status) {
                        var layerName = 'lppSMADealers';
                        var premierDealers = [],
                            strategicDealers = [],
                            allOtherDealers = [],
                            strategicProspects = [],
                            allOtherProspects = [],
                            houseAccounts = [],
                            cashAccounts = [],
                            lppStores = [];
                        window.clearTimeout(timeout);
                        context.setMaxCoordinates(result);
                        angular.forEach(result, function(value, key) {
                            if(value.properties.accountType === 'ca') {
                                cashAccounts.push(value);
                            } else if(value.properties.accountType === 'lpp') {
                                lppStores.push(value);
                            } else if(value.properties.accountType === 'ha') {
                                houseAccounts.push(value);
                            } else if(value.properties.accountType === 'pd') {
                                premierDealers.push(value);
                            } else if(value.properties.accountType === 'sd') {
                                strategicDealers.push(value);
                            } else if(value.properties.accountType === 'aod') {
                                allOtherDealers.push(value);
                            } else if(value.properties.accountType === 'sp') {
                                strategicProspects.push(value);
                            } else if(value.properties.accountType === 'aop') {
                                allOtherProspects.push(value);
                            };
                        });
                        setupResult(layerName + 'ca', mapbox.icoCashAccount, cashAccounts);
                        setupResult(layerName + 'lpp', mapbox.icoLPPStore, lppStores);
                        setupResult(layerName + 'ha', mapbox.icoHouseAccount, houseAccounts);
                        setupResult(layerName + 'pd', mapbox.icoPremierAcc, premierDealers);
                        setupResult(layerName + 'sd', mapbox.icoStrategicAcc, strategicDealers);
                        setupResult(layerName + 'aod', mapbox.icoOtherAcc, allOtherDealers);
                        setupResult(layerName + 'sp', mapbox.icoStategicProspect, strategicProspects);
                        setupResult(layerName + 'aop', mapbox.icoOtherProspect, allOtherProspects);

                        // Uncomment when feature to pan out and show all data in view is added
                        // showAllGeoDataInView()

                        $rootScope.$broadcast('remoteGetAccounts-complete');
                        //open the lpp store panel
                        $( ".leaflet-map-pane  img[src*='lpp']" ).click()
                    } else {
                        window.clearTimeout(timeout);
                        $rootScope.$broadcast('remoteGetAccounts-complete');
                        $rootScope.$broadcast('error', {'result' : event});
                    }
                }
            )
        },
    }

    function showAllGeoDataInView() {
        var maxCoordinates = context.getMaxCoordinates(),
            southWest = L.latLng(maxCoordinates.southWestLatLon[0], maxCoordinates.southWestLatLon[1]),
            northEast = L.latLng(maxCoordinates.northEastLatLon[0], maxCoordinates.northEastLatLon[1]),
            bounds = L.latLngBounds(southWest, northEast);
        mapbox.map.fitBounds(bounds);
    }

    function setupResult(name, accIcon, data) {
        var iconObj = accIcon != null ? {icon: accIcon} : {};
        var featureLayer = mapbox.layers[name] = L.geoJson(data, {
            pointToLayer: function (feature, latlng) {
                return L.marker(latlng, iconObj);
            }
        })
        .eachLayer(function(layer) {
            var viewRecord = context.sforceone ? 'sforce.one.navigateToSObject(\''+layer.feature.properties.accountId+'\')' : 'window.open(\'/'+layer.feature.properties.accountId+'\')';
            layer.bindPopup('<h4><a href="/'+layer.feature.properties.accountId+'">'+layer.feature.properties.title+'</a></h4>', {});

        })
        .addTo(mapbox.map);
        mapbox.addFeatureLayer(featureLayer);
    }
    
    function setupResultNew(name, accIcon, data) {
        console.log('In setupResultNew');
        var premier = [];
        var strategic = [];
        var others = [];
        var retails = [];
        data.forEach(function(element) {            
            if(element.properties.accountType ==="premier"){
                premier.push(element);
            }
            if(element.properties.accountType ==="strategic"){
                strategic.push(element);
            }
            if(element.properties.accountType ==="other"){
                others.push(element);
            }
            if(element.properties.accountType ==="retail"){
                retails.push(element);
            }
        });
        console.log('premier ', premier);
        setupResult(name, mapbox.icoPremierAcc, premier);
        console.log('strategic ', strategic);
        setupResult(name, mapbox.icoStrategicAcc, strategic);
        console.log('others ', others);
        setupResult(name, mapbox.icoOtherAcc, others);
		console.log('retails ', retails);
        if(name ==='cstdr0'){
            setupResult(name, mapbox.icoCostco, retails);
        }
        if(name ==='lwdr0'){
            setupResult(name, mapbox.icoLowes, retails);
        }
        if(name ==='hdr0'){
            setupResult(name, mapbox.icoHD, retails);
        }
    }

    function removeMapboxLayers() {
        mapbox.clearFeatureLayers();
    }

})

.controller('mapCtrl', function($scope, $window, $timeout, $rootScope, remoteMethods, localMethods, mapbox, context) {

    $scope.getMapStyle = function() {
        var height = window.innerHeight - 200;
        if(!context.sforceone) {
            return {'min-height' : height + 'px', 'margin' : '-10px'};
        }
        return {};
    }
    $scope.mapStyle = $scope.getMapStyle();
    $scope.mode = context.mode;
    $scope.isSidebarOpen = true;
    $scope.isAccountOpen = false;
    $scope.mapLoading = false;
    $scope.mapLoadingContent = '';
    $scope.resultCount = 0;


    mapbox.map.on('popupopen', function(e) {
        console.log(e);
        var accId = e.popup._source.feature.properties.accountId;
        var accountType = e.popup._source.feature.properties.accountType;
        context.disableAutoSearch();
        $scope.$apply(function() {
            $scope.isAccountOpen = true;
        })
        localMethods.setView(e.popup._source.feature.geometry.coordinates[1], e.popup._source.feature.geometry.coordinates[0], mapbox.map.getZoom());
        remoteMethods.getAccountData(accId, accountType);
    });
    mapbox.map.on('popupclose', function(e) {
        console.log('popupclose');
        if($scope.isAccountOpen) {
            $scope.closeAccountDetail();
            $rootScope.$broadcast('clear-account', {});
        }
    })
    $scope.$on('default-location-saved', function(event, args) {
        $scope.$apply(function() {
            $scope.finishMapLoading();
        })
    })
    $scope.$on('remoteGetAccounts-complete', function(event, args) {
        $scope.$apply(function() {
            $scope.finishMapLoading();
        })
    })
    $scope.$on('error', function(event, args) {
        alert('Error: ' + args.result);
    });
    $scope.$on('start-map-loading', function(event, args) {
        $scope.mapLoading = true;
        $scope.mapLoadingContent = args.mapLoadingContent;
        if(window.innerWidth < 768) {
            $scope.isSidebarOpen = false;
        }
    })
    $scope.$on('soql-limit-met', function(event, args) {
        window.alert('Your search returned too many results to display them all on the map.  Try narrowing your search or zooming in.');
        $rootScope.$broadcast('remoteGetAccounts-complete');
        $scope.$apply(function() {
            $scope.finishMapLoading();
        })
    })
    $scope.$on('close-sidebar', function(event, args) {
        $scope.toggleSidebar();
    })
    $scope.finishMapLoading = function() {
        $scope.mapLoadingContent = 'Done!';
        $timeout(function() {
            $scope.mapLoading = false;
            $scope.resultCount = document.querySelectorAll('.leaflet-marker-icon').length;
        }, 250);
    }

    $scope.toggleSidebar = function() {
        $scope.isSidebarOpen = !$scope.isSidebarOpen;
    }
    $scope.closeAccountDetail = function() {
        $scope.isAccountOpen = false;
    }
    $scope.saveDefaultLocation = function() {
        $scope.mapLoading = true;
        $scope.mapLoadingContent = 'Saving Default Location';
        var center = mapbox.map.getCenter(),
            zoom = mapbox.map.getZoom();
        remoteMethods.saveDefaultLocation(center.lat, center.lng, zoom);
    }
    $scope.setView = function() {
        if(currentUser.lat) {
            localMethods.setView(currentUser.lat, currentUser.lon, currentUser.zoom);
        } else if(currentUser.postalCode) {
            localMethods.geocode(currentUser.postalCode, null, false);
        } else {
            localMethods.setView(34.70549, -103.73291, 5);
        }
    }
    $scope.init = function() {
        $scope.setView();
        if(context.mode == 'Global') {
            remoteMethods.getDistricts();
        } else if(context.mode == 'DM') {
            remoteMethods.getTerritories(currentUser.district);
        } else if(context.mode == 'TM') {
            remoteMethods.getAccounts();
        }
    }

    mapbox.map.on('load', $scope.init);

})

.controller('redoSearchCtrl', function($rootScope, $scope, mapFilters, mapbox, remoteMethods, context) {
    $scope.showRedoSearchOnMapChange = mapFilters.showRedoSearchOnMapChange;
    $scope.showRedoSearch = mapFilters.showRedoSearch;
    $scope.autoSearch = false;
    $scope.toggleAutoSearch = function() {
        $scope.autoSearch = !$scope.autoSearch;
    }
    $scope.redoSearch = function() {
        console.log('scope.redoSearch',context.noAutoSearch);
        if(!context.noAutoSearch) {
            // TODO: need to check if searching by LPP store or normal filter search
            var searchType = context.getSearchType();
            console.log('searchType ', searchType);
            if(searchType === 'FILTER_BY_DEALER') {
                remoteMethods.getAccounts();
            } else if(searchType === 'LPP_STORE') {
                var accountId = context.getLPPStoreId();
                remoteMethods.getSMADealers(accountId);
            }

        	mapFilters.showRedoSearchOnMapChange = true;
        }
    }
    $scope.handleRedoSearch = function(e) {
        $scope.$apply(function() {
            if($scope.autoSearch) {
                $scope.redoSearch();
            } else if(mapFilters.showRedoSearchOnMapChange) {
                $scope.showRedoSearch = true;
            }
        })
    }
    mapbox.map.on('moveend', $scope.handleRedoSearch);
    mapbox.map.on('zoomend', $scope.handleRedoSearch);
    //mapbox.map.on('resize', $scope.handleRedoSearch);
    $scope.$on('start-map-loading', function(event, args) {
        $scope.showRedoSearch = false;
    })
    $scope.$on('remoteGetAccounts-complete', function() {
        $scope.showRedoSearchOnMapChange = true;
    })
})

.controller('searchCtrl', function($scope, localMethods) {
    $scope.searchVal;
    $scope.changeLocation = function(searchVal) {
        if(!isNaN(searchVal)) {
            searchVal += ', US';
        }
        localMethods.geocode(searchVal, null, true);
        if(window.innerWidth < 768) {
            $scope.$emit('close-sidebar');
        }
    }

})

.controller('accountDetailCtrl', function($scope, context, remoteMethods, mapFilters) {
    $scope.account = {};
    $scope.loading = true;
    $scope.sforceone = context.sforceone;
    $scope.fieldFilters = [
        {
            value: 'SAP_YTD_Sales__c',
            label: 'YTD Sales'
        },
        {
            value: 'Prior_Year_YTD_Sales__c',
            label: 'Prior Year YTD Sales'
        }
    ];
    $scope.salesFilters = {
        default: {
            minValue: undefined,
            maxValue: undefined
        },
        selectedFieldFilter: $scope.fieldFilters[0],
        useSalesFilter: false,
        minValue: undefined,
        maxValue: undefined,
        resetToDefault: function() {
            this.minValue = this.default.minValue;
            this.maxValue = this.default.maxValue;
        }
    };

    $scope.handleToggleFilterClick = function() {
        var useSalesFilter = !$scope.salesFilters.useSalesFilter;
        $scope.salesFilters.useSalesFilter = useSalesFilter;
        if(!useSalesFilter) {
            $scope.salesFilters.resetToDefault();
            mapFilters.resetSalesFieldFilters();
        }
    };

    $scope.handleShowStoreSMADealersClick = function(accountId) {
        mapFilters.setSalesFieldFilters($scope.salesFilters.selectedFieldFilter.value, $scope.salesFilters.minValue || 0, $scope.salesFilters.maxValue || 0, $scope.salesFilters.useSalesFilter);
        context.setSearchType('LPP_STORE');
        context.setLPPStoreId(accountId);
        remoteMethods.getSMADealers(accountId);
    };


    $scope.$on('clear-account', function() {
        $scope.account = {};
        $scope.$apply();
    })
    $scope.$on('account-data-returned', function(event, args) {
        $scope.loading = false;
        var replace = /&amp;/gi;
        args.result.name = args.result.name.replace(replace, '&');
        $scope.account = args.result;
        $scope.$apply();
    })
    $scope.viewRecord = function(recordId) {
        if(context.sforceone) {
            sforce.one.navigateToSObject(recordId);
        } else {
            window.open('/' + recordId);
        }
    }
    $scope.viewContacts = function(accountId) {
        if(context.sforceone) {
            sforce.one.navigateToRelatedList('Contacts', accountId);
        } else {
            //window.open('/003?rlid=RelatedContactList&id=' + accountId);
            window.open('/lightning/r/'+accountId+'/related/Contacts/view?0.source=alohaHeader');
        }
    }
    $scope.createScorecard = function(accountName, accountId) {
        var url = '/a06/e?CF00N80000002nJnk=' + accountName + '&CF00N80000002nJnk_lkid=' + accountId + '&retURL=%2F' + accountId + '&RecordType=012800000006Tm8&ent=01I80000000498w';
        window.open(url);
    }
})

.controller('filtersCtrl', function($rootScope, $scope, $filter, localMethods, remoteMethods, mapbox, context, mapFilters) {

    $scope.districts = [];
    $scope.territories = mapFilters.territories;
    $scope.territoriesCheckAll = false;
    $scope.selectedTerritoryIds = [];
    $scope.currentUser = currentUser;
    $scope.loading = context.mode == 'TM' ? false : true;
    $scope.selection = context.mode == 'Global' ? 'Districts' : context.mode == 'DM' ? 'Territories' : 'Dealers';
    $scope.dealerSelection = mapFilters.dealerSelection;
    $scope.filters = mapFilters.filters;
    $scope.attributeFilters = mapFilters.attributeFilters;

    $scope.fieldFilters = [
        {
            value: 'SAP_YTD_Sales__c',
            label: 'YTD Sales'
        },
        {
            value: 'Prior_Year_YTD_Sales__c',
            label: 'Prior Year YTD Sales'
        }
    ];
    $scope.salesFilters = {
        default: {
            minValue: undefined,
            maxValue: undefined
        },
        selectedFieldFilter: $scope.fieldFilters[0],
        useSalesFilter: false,
        minValue: undefined,
        maxValue: undefined,
        resetToDefault: function() {
            this.minValue = this.default.minValue;
            this.maxValue = this.default.maxValue;
        }
    };

    $scope.handleToggleFilterClick = function() {
        var useSalesFilter = !$scope.salesFilters.useSalesFilter;
        $scope.salesFilters.useSalesFilter = useSalesFilter;
        if(!useSalesFilter) {
            $scope.salesFilters.resetToDefault();
            mapFilters.resetSalesFieldFilters();
        }
    }


    $scope.$on('districts-returned', function(event, args) {
        $scope.$apply(function() {
            $scope.loading = false;
            $scope.districts = args.result;
        })
    })
    $scope.$on('territories-returned', function(event, args) {
        $scope.$apply(function() {
            $scope.loading = false;
            if(currentUser.role.indexOf('Res LPP SM') != -1) {
                angular.forEach(mapFilters.territories, function(value, key) {
                    value.selected = false;
                })
                $scope.territoriesCheckAll = true;
            }
            $scope.territories = mapFilters.territories;
            if(context.mode == 'DM' && currentUser.role.indexOf('Res LPP SM') == -1) {
                $scope.getAccounts();
            }
        })
    })

    $scope.selectDistrict = function(district, location) {
        $scope.loading = true;
        localMethods.geocode(location, 6, false);
        remoteMethods.getTerritories(district);
        $scope.selection = 'Territories';
    }
    $scope.selectTerritory = function(territory) {
        territory.selected = !territory.selected;
    }
    $scope.changeSelection = function(selection) {
        if(selection == 'Dealers' && currentUser.role.indexOf('Res LPP SM') != -1 && $filter('filter')($scope.territories, {selected: true}).length > 0) {
            angular.forEach(mapFilters.filters.dealers.options, function(value, key) {
                value.active = true;
            })
            mapFilters.filters.dealers.checkAll = false;
        }
        $scope.selection = selection;
    }
    $scope.changeDealerSelection = function(selection) {
        $scope.dealerSelection = selection;
        mapFilters.dealerSelection = selection;
    }
    $scope.toggleCheckAllTerritories = function() {
        $scope.territoriesCheckAll = !$scope.territoriesCheckAll;
        if(!$scope.territoriesCheckAll) {
            angular.forEach($scope.territories, function(value, key) {
                value.selected = true;
            })
        } else {
            angular.forEach($scope.territories, function(value, key) {
                value.selected = false;
            })
        }
    }
    $scope.uncheckAllTerritories = function() {
        $scope.territoriesCheckAll = true;
        angular.forEach($scope.territories, function(value, key) {
            value.selected = false;
        })
    }
    $scope.toggleCheckAll = function(filterObj) {
        filterObj.checkAll = !filterObj.checkAll;
        if(!filterObj.checkAll) {
            angular.forEach(filterObj.options, function(value, key) {
                value.active = true;
            })
        } else {
            angular.forEach(filterObj.options, function(value, key) {
                value.active = false;
            })
        }
    }
    $scope.toggleVisibility = function(filterObj, e) {
        e.stopPropagation()
        filterObj.optionsVisible = !filterObj.optionsVisible;
    }
    $scope.selectCheckbox = function(item) {
        item.active = !item.active;
        var allActive = false;
        angular.forEach($scope.territories, function(value, key) {
            if(value.active) {
                allActive = true;
            } else {
                allActive = false;
            }
        })
        if(allActive) {
            $scope.checkAllTerritories = false;
        } else {
            $scope.checkAllTerritories = true;
        }
    }
    $scope.selectRadio = function(item, items) {
        angular.forEach(items, function(value, key) {
            value.active = false;
        })
        item.active = true;
    }
    $scope.getAccounts = function() {
        mapFilters.setSalesFieldFilters($scope.salesFilters.selectedFieldFilter.value, $scope.salesFilters.minValue || 0, $scope.salesFilters.maxValue || 0, $scope.salesFilters.useSalesFilter);
        context.setSearchType('FILTER_BY_DEALER');
        remoteMethods.getAccounts();
        mapFilters.showRedoSearchOnMapChange = true;
    }

})