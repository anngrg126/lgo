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
  //add or remove hidden class to navbar & manage sticky
  if ($(window).width() > 639) {
    $("#tags-menu").addClass("is-hidden");
    
  } else {
    $("#tags-menu").removeClass("is-hidden");
    if ($("nav.sticky").hasClass("is-at-bottom")) {
      $("nav.sticky").removeClass("is-at-bottom").css("top", 0);
    };
  };
  //fcn to populate text of "Back" button in responsive menu  
  if ($(".nav-bottomtier ul.horizontal").hasClass("drilldown")) {
    $(this).find(".occasion .js-drilldown-back").html('<a tabindex="0">Browse by Occasion</a>');
    $(this).find(".relationship .js-drilldown-back").html('<a tabindex="0">Browse by Relationship</a>');
    $(this).find(".type .js-drilldown-back").html('<a tabindex="0">Browse by Type</a>');
    $(this).find(".interests .js-drilldown-back").html('<a tabindex="0">Browse by Interests</a>');
  }
  //fcn to toggle navbar browse
  if ($("#browse_navbar").children().hasClass('active')) {
    $("#tags-menu").removeClass("is-hidden");
  };
  if ($(window).width() < 640) {
    if ($(".nav-midtier button h6").hasClass("active")) {
      $(".nav-midtier button h6").removeClass("active");
      $(".nav-midtier button h6").closest(".columns").removeClass("active");
    };
  };
  //set correct height of navbar
  if (!($(".sticky").height() < 52)) {
    $(".sticky-container").css("height", $(".sticky").height());
  } else {
    $(".sticky-container").css("height", 52);
  };
  //*STORY FORM*
  //fcns to append extra image upload fields
  $('#add_image_fields').click(function(){
    $("#image_fields div:first-child").clone().insertAfter( $("#image_fields")).append('<a class="remove_image_field" data-remote= true href="javascript:">Remove image</a>');
  });
  //*Story Show View*
  $('a[href^="#comments"], a[href^="#stickhere"], a[href^="#featured_prompt"]').on('click', function(e){
    e.preventDefault();
    var target = this.hash;
    var $target = $(target);
    $('html, body').stop().animate({
      'scrollTop': $target.offset().top
    }, 500, 'swing');
  });
  //*Dashboard View*
  $('.header-nav .list a, .user-dashboard .list').on('click', function(e){
    if ($(window).width() < 640) {
      e.preventDefault();
      var $target = $('#dashboard_partial');
      $('html, body').stop().animate({
        'scrollTop': $target.offset().top
      }, 500, 'swing');
    }
  });
  if ($(window).width() < 640) {
    $(window).bind('scroll', function(){
      if($(this).scrollTop()>500) {
        $("#go-to-top").show();
      } else {
        $("#go-to-top").hide();
      }
    })
  };
};

//*NAVBAR
$(document).on('click', '#browse_navbar', function(event){
  if ($(window).width() > 639) {
    if ($(this).children().hasClass('active')) {
      $(this).children().removeClass('active');
      $(this).parent().removeClass('active');
      $(".sticky-container").css("height", $(".sticky").height());
    } else {
      $(this).children().addClass('active');
      $(this).parent().addClass('active');
      $(".sticky-container").css("height", $(".sticky").height());
    };
  } else {
    if ($(this).children().hasClass('active')) {
      $(this).children().removeClass('active');
      $(this).closest(".columns").removeClass('active');
      $(".sticky-container").css("height", $(".sticky").height());
    } else {
      $(this).children().addClass('active');
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
//fcn to change text of image upload label
function uploadLabel() {
  $( '.image-input' ).on( 'change', function( e ) {
    var fileCount = '',
        fileName  = '',
        $label	  = $( this ).next( 'label' ),
        links     = '';
    if( this.files && this.files.length > 1 ) {
      //fileName = ( this.getAttribute( 'data-multiple-caption' ) || '' ).replace( '{count}', this.files.length );
      fileCount = this.files.length
    } else if( e.target.value ) {
      fileName = e.target.value.split( '\\' ).pop();
    };
    if( fileCount ) {
      if (fileCount > 1) {
        $label.find( 'p' ).html( fileCount.toString()+" files selected" );
      } else {
        $label.find( 'p' ).html( fileCount.toString()+" file selected" );
      }
      links = true;
    } else {
        //$label.html( labelVal );
    };
    if( fileName ) {
      $label.find( 'p' ).html( fileName );
      links = true;
    }
    if (links) {
      $(".links").css("display", "block"); 
      $(this).siblings("a.remove_fields").css("display", "inline-block");
    }
  });
  // Firefox bug fix
  $( '.image-input' )
  .on( 'focus', function(){ $( this ).addClass( 'has-focus' ); })
  .on( 'blur', function(){ $( this ).removeClass( 'has-focus' ); });
};
//fcn to hinder built-in capability of trix editor to accept embedded files
document.addEventListener("trix-file-accept", function(event) {
  event.preventDefault()
})

$(document).ready(myFunction);
$(document).on('turbolinks:load', myFunction);