apt_home = {
  loadFeaturedBuildings: function() {
    $.ajax({
      url: '/load_featured_buildings',
      dataType: 'script',
      type: 'get',
      success: function() {
        apt_home.loadImages();
      }
    });
  },

  loadImages: function() {
    var figure;
    var figures = $('.figure');
    
    for(var i = 0; i < figures.length; i++) {
      figure = figures[i];
      Card.loadDisplayImageAndCTALinks($(figure.parentNode.parentNode));
    }
  }
}

window.onload = function() {
  if($('.home-wrapper > .featured-section').length > 0){
    setTimeout(function(){
      apt_home.loadFeaturedBuildings();
    }, 3000);
  }
}