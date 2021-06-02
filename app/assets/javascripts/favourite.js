//document.addEventListener('DOMContentLoaded', function() {
  // favourite script for market infowindow
  $('.unfilled-heart').mouseover(function(){
    var notFav = $('.unfilled-heart').find('span');
    if(!notFav.hasClass('hover')){
      notFav.addClass('hover');
    }
  });

  function saveToFavourite(object_id){
    var save_link = $('.save_link_'+object_id);
    var unfav_link = '<a class="favourite save_link_'+object_id+' filled-heart" title="Unsave" data-objectid="'+object_id+'"  href="javascript:;" onclick="removeFromFavourite('+object_id+')"><span class="fa fa-heart"></span></a>';

    $.ajax({
      url: '/favorite?object_id='+object_id,
      type: 'post',
      beforeSend: function(xhr){
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
      },
      dataType: 'json',
      success: function(response){
        replace_link(save_link, unfav_link)
      }
    });
  }

  function removeFromFavourite(object_id){
    var save_link = $('.save_link_'+object_id);
    var fav_link = '<a class="favourite save_link_'+object_id+' unfilled-heart" title="Save" data-objectid="'+object_id+'"  href="javascript:;" onclick="saveToFavourite('+object_id+')" onmouseleave="addLeaveEffect('+object_id+', this)"><span class="fa fa-heart"></span></a>';

    $.ajax({
      url: '/unfavorite.json',
      type: 'get',
      dataType: 'json',
      data: { object_id: object_id },
      success: function(response){
        replace_link(save_link, fav_link);
      }
    });
  }

  // adding mouseover effect once leave
  function addLeaveEffect(object_id, elem){
    var to_replace = $(elem);
    var replace_with = '<a class="favourite save_link_'+object_id+' unfilled-heart" title="Save" data-objectid="'+object_id+'"  href="javascript:;" onclick="saveToFavourite('+object_id+')" onmouseover="addHoverEffect('+object_id+', this)"><span class="fa fa-heart"></span></a>';

    replace_link(to_replace, replace_with);
  }

  function replace_link(to_replace, replace_with){
    to_replace.replaceWith(function(){
      return replace_with
    });
  }

  function removeHoverEffect(id){} //for declare purpose only

  function addHoverEffect(object_id){
    var notFav = $('.unfilled-heart').find('span');
    if(!notFav.hasClass('hover')){
      notFav.addClass('hover');
    }
  }

  function openSuModal(e, object_id){
    e.preventDefault();
    e.stopPropagation();
    $.ajax({
      url: '/favorite?object_id='+object_id,
      type: 'post',
      beforeSend: function(xhr){
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
      },
      dataType: 'script',
      success: function(response){
        //console.log('success')
      }
    });
  }
  //END favorite script

  $("a.unfilled-heart").click(function (event) {
    if(this.dataset.remote != 'true'){
      event.preventDefault();
      event.stopPropagation();
    }
  });
//}, false);