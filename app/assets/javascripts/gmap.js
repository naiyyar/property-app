function createSidebarElem(json){
  title = json.marker_title.split(',');
  building_name = title[1];
  address = title[2];
  zipcode = title[3];
  full_address = address +', '+zipcode
  if(building_name == ' '){
    building_name = full_address
  }
  return ("<h2>" + building_name + "</h2>" +
  					"<div class='cardAddress'><span class='icon-location-pin'></span>"+ full_address +"</div>"
          );
};

function bindElemToMarker(elem, marker){
  elem.on('mouseover', function(){
    //handler.getMap().setZoom(15);
    marker.serviceObject.setIcon("assets/marker-green.png");
    //marker.setMap(handler.getMap()); //because clusterer removes map property from marker
    //marker.panTo();
    //google.maps.event.trigger(marker.getServiceObject(), 'click');
  }).on('mouseout', function(){
    marker.serviceObject.setIcon("assets/marker-blue.png")
  })
};

function bindMarker(marker, markers, handler, lat, lng, zoom){
  $(window).on('load', function(){
    marker.serviceObject.setIcon("assets/marker-blue.png")
    marker.setMap(handler.getMap());
    marker.panTo();
    google.maps.event.trigger(marker.getServiceObject(), 'load');
    handler.bounds.extendWith(markers);
    //handler.fitMapToBounds();
    handler.getMap().setZoom(zoom);
    handler.map.centerOn(marker);
  })
};

function createSidebar(json_array){
  _.each(json_array, function(json){
    var elem = $( createSidebarElem(json) );
    var id = json.marker_title.split(',')[0]
    elem.appendTo('#building_details'+id);
    bindElemToMarker(elem, json.marker);
  });
};