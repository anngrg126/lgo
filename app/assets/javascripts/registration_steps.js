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
};

//fcn to load all radio buttons as unchecked
$(document).ready(function() {
  $('input[type="radio"]').removeAttr("checked");
});

$(document).ready(myFunction);