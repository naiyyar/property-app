function displayMap(a){handler=Gmaps.build("Google"),handler.buildMap({provider:{},internal:{id:"mapView"}},function(){markers=handler.addMarkers(a),handler.bounds.extendWith(markers),handler.fitMapToBounds(),handler.getMap().setZoom(14)})}