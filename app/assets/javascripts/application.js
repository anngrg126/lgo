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
//= require cocoon
//= require_tree .

//$(function(){  });
$(document).on('turbolinks:load', function() {
  $(document).foundation();
});

function myFunction() {
  //fcn to populate text of "Back" button in responsive menu  
  if ($("#navbar-tier2").hasClass("drilldown")) {
    $(this).find(".occasion .js-drilldown-back").html('<a tabindex="0">Browse by Occasion</a>');
    $(this).find(".relationship .js-drilldown-back").html('<a tabindex="0">Browse by Relationship</a>');
    $(this).find(".type .js-drilldown-back").html('<a tabindex="0">Browse by Type</a>');
    $(this).find(".interests .js-drilldown-back").html('<a tabindex="0">Browse by Interests</a>');
  }
  
  //fcns to append extra image upload fields
  $('#add_image_fields').click(function(){
    $("#image_fields div:first-child").clone().insertAfter( $("#image_fields")).append('<a class="remove_image_field" data-remote= true href="javascript:">Remove image</a>');
  });
  
  //fcn to toggle active class on navbar
   var current_url = window.location.href.substr(window.location.href
.split("/")+1);
  console.log(current_url);
   $("nav .menu-text").each(function(){
      if($(this).attr("href") == current_url || $(this).attr("current_url") == '' )
      $(this).addClass("active");
   })
};

//fcn to remove extra image upload fields, separate b/c dynamically-added element
$(document).on('click', '.remove_image_field', function(event){
  $(this).closest(".upload_image").remove();
});

//fcn to hinder built-in capability of trix editor to accept embedded files
document.addEventListener("trix-file-accept", function(event) {
  event.preventDefault()
})

//fcn to show/hide custom gender field when updating information via user dashboard
$( document ).ajaxComplete(function( event,request, settings ) {
  $("#custom_defined_gender").click(function(){
    myFunction();
  });
});

$(document).ready(myFunction);
$(document).on('turbolinks:load', myFunction);