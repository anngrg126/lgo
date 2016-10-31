// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
//= require foundation
//= require turbolinks
//= require trix
//= require_tree .

//$(function(){  });
$(document).on('turbolinks:load', function() {
  $(document).foundation();
});

$(function(){
  //fcn to show custom gender field
  $('input[type="radio"]').change(function() {
    var id = $(this).attr('id');
    if(id=="custom_defined_gender") {
      $("#free_system_input").show();
    } else {
      $("#free_system_input").hide();
    };
  });
  
  //fcn to set value of custom gender
  $('#free_system_input').keyup( function(){
    if ( $(this).val() !== "" ) { $('#custom_defined_gender').val($(this).val());
    } else { $('#custom_defined_gender').val("custom");
    };
  });
});

$(document).ready(function() {
  $('input[type="radio"]').removeAttr("checked");
});

document.addEventListener("trix-file-accept", function(event) {
  event.preventDefault()
})