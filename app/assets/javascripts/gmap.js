// function createSidebarElem(json){
//   // title = json.marker_title.split(',')
//   // building_name = title[1]
//   // address = title[2]
//   // zipcode = title[3]
//   // return ("<h4 class='list-group-item-heading'>" + building_name + "</h4>" +
//   // 					"<p class='list-group-item-text'>"+ address +', '+zipcode+"</p>"
//   //         );
// };

function bindElemToMarker(elem, marker){
  elem.on('click', function(){
    handler.getMap().setZoom(15);
    marker.setMap(handler.getMap()); //because clusterer removes map property from marker
    marker.panTo();
    google.maps.event.trigger(marker.getServiceObject(), 'click');
  })
};

function bindMarker(marker, markers, handler, lat, lng, zoom){
  $(window).on('load', function(){
    //kmls = handler.addKml({ url: "http://gmaps-samples.googlecode.com/svn/trunk/ggeoxml/cta.kml" });
    marker.setMap(handler.getMap());
    marker.panTo();
    google.maps.event.trigger(marker.getServiceObject(), 'load');
    
    //handler.bounds.extendWith(kmls);
    handler.fitMapToBounds();
    handler.map.centerOn({lat: lat, lng: lng})
    handler.getMap().setZoom(zoom);
    handler.bounds.extendWith(polygons);
    handler.bounds.extendWith(markers);
  })
};

function createSidebar(json_array){
  _.each(json_array, function(json){
    var elem = $( createSidebarElem(json) );
    var id = json.marker_title.split(',')[0]
    elem.appendTo('#apt_sidebar_container'+id);
    bindElemToMarker(elem, json.marker);
  });
};