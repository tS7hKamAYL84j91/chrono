// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"


$(function(){
  $('button#register').on('click', function(e){
        e.preventDefault();
        $.ajax({
            url: "/contacts",
            type: "POST",
            data: $("form#contact_form").serialize(),
            success: function(data){
                console.log(data)
                $("form#contact_form").each(function(){
                    this.reset();
                    grecaptcha.reset();
                });
            },
            error: function(resp) { 
                console.log(resp); 
                grecaptcha.reset();
            }
        });
  }); 
});


// Menu Overlay function
$(function() {
	var bodyEl = document.body,
		isOpen = false;

	$('#menu-link, .close-menu, .overlay-menu a').on('click', function(){
		$(bodyEl).toggleClass('menu-open');
		$('#menu-link').toggleClass('is-clicked');
		$("#overlay").toggleClass("open");
		isOpen = !isOpen;
		if(location.hostname === this.hostname){
			return false;
		}
	});	
});

/*============================
=            Core            =
============================*/

// Waypoints Animations 
$(window).load(function(){
	
	$('.anima').waypoint(function(){
		$(this).addClass('in');
	},{offset:'95%'});
	
});

$(function() {

		// Smooth Hash Link Scroll
		$('.smooth-scroll').click(function() {
			if (location.pathname.replace(/^\//,'') === this.pathname.replace(/^\//,'') && location.hostname === this.hostname) {
		
				var target = $(this.hash);
				target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
				if (target.length) {
					$('html,body').animate({
						scrollTop: target.offset().top
					}, 1000);
					return false;
				}
			}
			});

	// full-height 
	function heroHeight() {
		var $this = $('#hero'),
		win = $(window),
		dataHeight = $this.data('height');

		if ($this.hasClass('full-height')) {
			$this.css({
				'height': (win.height())
			});
		} else {
			$this.css({
				'height': dataHeight + 'em'
			});
		}
	}
	// Start 
	heroHeight();
	$(window).resize(heroHeight);


});

/*-----  End of Core  ------*/

/*=======================================
=            Counter numbers            =
=======================================*/

$(function() {

	$('.counter').counterUp({
			time: 1000
	});

});

/*-----  End of Counter numbers  ------*/


