import "bootstrap";
import "jquery";


const selectDiv = document.getElementById("select");

if (selectDiv) {
    console.log("toto");
    $(document).ready(function() {
        $('#select').change(function() {
           $.ajax({
             url: `/dashboards?country="${$("#select option:selected").val()}"`,
             data: {"country": $("#select option:selected").val()},
            //  dataType: "script",
             method: "get",
             success: function(r){}
           });
           console.log($("#select option:selected").val())
         });
       });
};

