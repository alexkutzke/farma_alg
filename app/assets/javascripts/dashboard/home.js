$(document).ready(function(){
  $("body").on("click",".answer-btn",function(){
    var message_id = $(this).data("message-id");
    $.ajax({
      url: "/dashboard/answers/show",
      data: {
        id: $(this).data("id")
      },
      type: "get"    
    });
  });

  $("body").on("click",".connection-btn",function(){
    $.ajax({
        url: "/dashboard/connections/show",
        type: "get",
        data: {id:$(this).data("id")},
        success: function(){
          //console.log("OK");
        }
    });
  });

});