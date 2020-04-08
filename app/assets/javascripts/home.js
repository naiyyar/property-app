(function($) {
    "use strict";
    
    if(!(('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch)) {
        $('body').addClass('no-touch');
    }

    setTimeout(function() {
        $('body').removeClass('notransition');
    }, 300);

    $('.dropdown-select li a').click(function() {
        if (!($(this).parent().hasClass('disabled'))) {
            $(this).prev().prop("checked", true);
            $(this).parent().siblings().removeClass('active');
            $(this).parent().addClass('active');
            $(this).parent().parent().siblings('.dropdown-toggle').children('.dropdown-label').html($(this).text());
        }
    });

    $(document).on('click', function(e){
        e.stopPropagation();
        if(e.target.id != 'search_term' && e.target.id != 'location-link'){
            hideAutoSearchList();
        }
    })

    $(document).on('keyup', '#search_term', function(e){
        // e.keyCode != 40 || e.keyCode != 38 for key up / down
        // home page search
        if((e.keyCode != 40 && e.keyCode != 38)){
            if($('#search_term').val() == ''){
                hideAutoSearchList();
            }
        }
    });

    function hideAutoSearchList(){
        // setInterval because no match link was not working: hiding too early
        setTimeout(function(){
            if($("ul.ui-autocomplete").is(":visible")) {
                $("ul.ui-autocomplete").hide();
            }
            $('.no-match-link').addClass('hidden');
            $('#search_term').addClass('border-bottom-lr-radius');
        }, 200);
    }

    // Searching building on neighborhood click
    if($('.borough-neighborhood').length > 0){
        $('.borough-neighborhood').click(function(e){
            e.preventDefault();
            $('#neighborhoods').val($(this).text());
            var nbh = $(this).data('nhname');
            var search_btn = $('.search-btn-submit');
            $('#apt-search-txt').val(nbh);
            search_btn.click();
            if(search_btn.length > 0) {
                search_btn.click();
            }
        })
    }

    $('.panel-collapse').on('show.bs.collapse', function () {
        $(this).prev().find('span').removeClass('fa-angle-down').addClass('fa-angle-up');
    });

    $('.panel-collapse').on('hide.bs.collapse', function () {
        $(this).prev().find('span').removeClass('fa-angle-up').addClass('fa-angle-down');
    });

    //To changes the size of search field on mobile device orientation changed
    window.addEventListener('resize', function() {
        var homeSearchContainer  = $('.home-search-form  .easy-autocomplete');
        var splitSearchContainer = $('.split-view-seach  .easy-autocomplete');
        setTimeout(function(){
            if(window.innerWidth > 500 && window.innerWidth <= 667){
                homeSearchContainer.css('width','649px');
                splitSearchContainer.css('width','581px');
            }
            else if(window.innerWidth > 667 && window.innerWidth <= 736){
                homeSearchContainer.css('width','715px');
                splitSearchContainer.css('width','646px');
            }
            else if(window.innerWidth == 375){
                homeSearchContainer.css('width','355px');
                splitSearchContainer.css('width','289px');
            }
            else if(window.innerWidth == 414){
                homeSearchContainer.css('width','394px');
                splitSearchContainer.css('width','322px');
            }
        }, 200);
    }, false);
})(jQuery);