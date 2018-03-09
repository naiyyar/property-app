app.apartments = function() {
  this._input = $('#apt-search-txt, #apt-search-txt-searchpage');
  this._initAutocomplete();
};

app.apartments.prototype = {
  _initAutocomplete: function() {
    this._input
      .autocomplete({
        source: '/search',
        prependTo: '#apt-search-results',
        select: $.proxy(this._select, this),
        open: $.proxy(this._open, this),
        search: $.proxy(this._search, this),
        close: $.proxy(this._close, this)
      })
      .autocomplete('instance')._renderItem = $.proxy(this._render, this);
  },

  _search: function(e,ui){
    this._input.addClass('loader');
  },

  _open: function(event, ui) {
    this._input.removeClass('loader');
    var ul_height = $('ul.ui-autocomplete').height();
    if($('#apt-search-txt-searchpage').length > 0){
      // $('ul.ui-autocomplete').css('width', $('#apt-search-txt-searchpage').width());
    }
    else{
      $('ul.ui-autocomplete').css('width', $('#apt-search-txt').width()+80+'px');
    }
    $('.no-match-link').css('top',ul_height+'px');
    $('.no-match-link').removeClass('hidden');
    $('.no-match-link').css('width', $('ul.ui-autocomplete').width()+2+'px');
    // $('.ui-autocomplete').append('<li class="ui-menu-item building_link_li"><p class="address"><a href="/buildings/contribute?results=no-matches-found"><b>' + search_term + '</b></a></p></li>');
  },

  _render: function(ul, item) {
    if(item.search_term == undefined){
      search_term = item.value
    }
    else{
      search_term = item.search_term
    }
    this._input.removeClass('loader');
    var items = ''
    if(search_term != 'No matches found - Add a new building'){
      //items = '<p class="address"><a href="/buildings/contribute?results=no-matches-found"><b>' + search_term + '</b></a></p>'
    //}
    //else{
      if(search_term != undefined){
        items = '<p class="address"><b>' + search_term + '</b></p>';
      }
    }
    
    var markup = [items];
    $('ul.ui-autocomplete').css('left','10');
    return $('<li>')
      .append(markup.join(''))
      .appendTo(ul);
  },

  _select: function(e, ui) {
    this._input.val(ui.item.search_term);
    $("#term").val(ui.item.term);
    $("#neighborhoods").val(ui.item.neighborhoods);
    $("#apt-search-txt-form").val(ui.item.search_term);
    $('#apt-search-form').find('.in_header').click();
    if($('#home-search-btn, #home-search-btn-mob').hasClass('disabled')){
      $('#home-search-btn, #home-search-btn-mob').removeClass('disabled')
    }
    $('.no-match-link').addClass('hidden');
    //home page
    $('#home-search-btn').click();
    return false;
  },
  _close: function(){
    //Hiding no match found - add new building link
    setTimeout(function(){ $('.no-match-link').addClass('hidden') }, 400);
    
  }


};