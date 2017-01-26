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


//foundation first because myFunction for navbar depends on foundation running
$(document).on('turbolinks:load', function() {
  $(document).foundation();
  //fcn to reinitialize sticky or non-sticky navbar with turbolinks + window resizing
  $(window).trigger('load.zf.sticky');
  $(".sticky").css("max-width", "none");
});


function myFunction() {
  //*NAVBAR*
  //add or remove hidden class to navbar 
  if ($(window).width() > 639) {
    $("#tags-menu").addClass("is-hidden");
    
  } else {
    $("#tags-menu").removeClass("is-hidden");
  };
  
  //fcn to populate text of "Back" button in responsive menu  
  if ($("#navbar-tier2").hasClass("drilldown")) {
    $(this).find(".occasion .js-drilldown-back").html('<a tabindex="0">Browse by Occasion</a>');
    $(this).find(".relationship .js-drilldown-back").html('<a tabindex="0">Browse by Relationship</a>');
    $(this).find(".type .js-drilldown-back").html('<a tabindex="0">Browse by Type</a>');
    $(this).find(".interests .js-drilldown-back").html('<a tabindex="0">Browse by Interests</a>');
  }
  //fcn to toggle navbar browse
  if ($("#browse_navbar").hasClass('active')) {
    $("#tags-menu").removeClass("is-hidden");
    $(".data-sticky-container").css("height", $(".sticky").height());
  };
  if ($(window).width() < 640) {
    if ($(".top-bar.center button").hasClass("active")) {
      $(".top-bar.center button").removeClass("active");
      $(".top-bar.center button").closest(".columns").removeClass("active");
    };
  };
  
  //*STORY FORM*
  //fcns to append extra image upload fields
  $('#add_image_fields').click(function(){
    $("#image_fields div:first-child").clone().insertAfter( $("#image_fields")).append('<a class="remove_image_field" data-remote= true href="javascript:">Remove image</a>');
  });
  
};

//*NAVBAR
$(document).on('click', '#browse_navbar', function(event){
  if ($(window).width() > 639) {
    if ($(this).hasClass('active')) {
      $(this).removeClass('active');
      $(this).parent().removeClass('active');
      $(".sticky-container").css("height", $(".sticky").height());
    } else {
      $(this).addClass('active');
      $(this).parent().addClass('active');
      $(".sticky-container").css("height", $(".sticky").height());
    };
  } else {
    if ($(this).hasClass('active')) {
      $(this).removeClass('active');
      $(this).closest(".columns").removeClass('active');
      $(".sticky-container").css("height", $(".sticky").height());
    } else {
      $(this).addClass('active');
      $(this).closest(".columns").addClass('active');
      $(".sticky-container").css("height", $(".sticky").height());
    };
  };
});
$(document).on('click', '.dropdown_category', function(event){
  if ($(window).width() > 639) {
    event.preventDefault();
  };
});
$(document).on("on.zf.toggler", function(e) {
  $("#mobile_search").closest("button").addClass('active');
  $("#mobile_search").closest("button").parent().addClass('active');
  $(".sticky-container").css("height", $(".sticky").height());
});
$(document).on("off.zf.toggler", function(e) {
  $("#mobile_search").closest("button").removeClass('active');
  $("#mobile_search").closest("button").parent().removeClass('active');
  $(".sticky-container").css("height", $(".sticky").height());
});
$("#mobile_search").click(function(e) {
  if ($("#mobile_search").closest("button").hasClass("active")) {
    $("#mobile_search").closest("button").removeClass('active');
    $("#mobile_search").closest("button").parent().removeClass('active');
  } else {
    $("#mobile_search").closest("button").addClass('active');
    $("#mobile_search").closest("button").parent().addClass('active');
  }
});
//fcn to handle user_dropdown
$(document).on("show.zf.dropdown", function(e) {
  if ($("#user_dropdown").hasClass("is-open")) {
    var position_top = $("#user_dropdown").css("top");
    position_top = parseInt(position_top.substr(0, position_top.length-2))+8;
    position_top.toString;
    position_top+="px";
    $("#user_dropdown").css("top", position_top);
  }  
});
$(document).on("hide.zf.dropdown", function(e) {
  if ($("#user_dropdown").hasClass("right")) {
    $("#user_dropdown").removeClass("right").addClass("bottom");
  }
});
//*STORY FORM*
//fcn to remove extra image upload fields, separate b/c dynamically-added element
$(document).on('click', '.remove_image_field', function(event){
  $(this).closest(".upload_image").remove();
});

//fcn to hinder built-in capability of trix editor to accept embedded files
document.addEventListener("trix-file-accept", function(event) {
  event.preventDefault()
})

$(document).ready(myFunction);
$(document).on('turbolinks:load', myFunction);