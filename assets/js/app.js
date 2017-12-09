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
  $('button#submit').on('click', function(e){
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
