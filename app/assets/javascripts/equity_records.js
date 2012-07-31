//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/



$(document).ready(function () {
//alert("document ready");
    $("#Person_Partial").hide();
    $("#equity_record_person_id").bind("change", equity_record_person_id_change);
});

function equity_record_person_id_change()
{
    if($("#equity_record_person_id").val() == "")
        $("#Person_Partial").show();
    else
        $("#Person_Partial").hide();

}