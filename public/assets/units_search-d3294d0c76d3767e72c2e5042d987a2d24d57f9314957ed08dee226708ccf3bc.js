app.units=function(e){this._input=$("#units-search-txt"),this._initAutocomplete(e)},app.units.prototype={_initAutocomplete:function(e){this._input.autocomplete({source:"/units/units_search?building_id="+e,appendTo:"#units-search-results",select:$.proxy(this._select,this),response:$.proxy(this._response,this),open:$.proxy(this._open,this)}).autocomplete("instance")._renderItem=$.proxy(this._render,this)},_open:function(){$(".ui-autocomplete").append('<li class="ui-menu-item building_link_li"><span class="address"><b>Unit Not Here?</b></span> <a href="javascript:void(0)" id="add_new_unit" class="add_new_unit"> Add a Unit</a></li>')},_render:function(e,t){$("#units-search-no-results").css("display","none");var i=['<p class="address"><b>'+t.name+"</b></p>"];return $("<li>").append(i.join("")).appendTo(e)},_select:function(e,t){this._input.val(t.item.name);var i=$("#unit_contribution").val();if("unit_review"==i||"unit_photos"==i||"unit_amenities"==i||"unit_price_history"==i){"unit_review"==i&&(href="/reviews/new",$("#new_unit_building").attr("action",href),$("#new_unit_building").attr("method","get")),$("#new_unit_building").removeClass("hide"),$(".square_feet_help_block").addClass("hidden");var n=t.item,s=null==n.square_feet?"":parseInt(n.square_feet);$("#unit_id").val(n.id),$("#unit_name").val(n.name),$("#unit_square_feet").val(s),$("#unit_number_of_bedrooms").val(n.number_of_bedrooms),$("#unit_number_of_bathrooms").val(n.number_of_bathrooms),"unit_amenities"==i&&(href="/units/"+n.id+"/edit",$("#search_item_form").attr("action",href))}return!1},_response:function(e,t){if(0===t.content.length){var i=$("#units-search-no-results"),n=['<p class="address"><b>Unit Not Here?</b></p>','Contribute by<a href="javascript:void(0)" id="add_new_unit"> adding a new unit</a>'];ul_li=$('<li class="no-result-li">').append(n.join("")),i.html(ul_li),i.css({display:"block",width:"555px",top:"36px",left:"15px"})}}};