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
  
  //fcns to append extra image upload fields
  $('#add_image_fields').click(function(){
    $("#image_fields div:first-child").clone().insertAfter( $("#image_fields")).append('<a class="remove_image_field" data-remote= true href="javascript:">Remove image</a>');
  });
};

//fcn to remove extra image upload fields, separate b/c dynamically-added element
$(document).on('click', '.remove_image_field', function(event){
  $(this).closest(".upload_image").remove();
});

//fcn to load all radio buttons as unchecked
$(document).ready(function() {
  $('input[type="radio"]').removeAttr("checked");
});

//fcn to hinder built-in capability of trix editor to accept embedded files
document.addEventListener("trix-file-accept", function(event) {
  event.preventDefault()
})

$(document).ready(myFunction);
$(document).on('turbolinks:load', myFunction);