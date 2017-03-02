function myFunction2() {
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
};

//*USER DASHBOARD
//fcn to show/hide custom gender field when updating information via user dashboard
$(document).ajaxComplete(function() {
  myFunction2();
});

$(document).ready(myFunction2);
$(document).on('turbolinks:load', myFunction2);
