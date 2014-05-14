/*
var current_nav = null;

function switch_nav(ev)
{
  // clean all actives
  if (current_nav)
    $("#"+current_nav).removeClass("active");

  // clean up the old nav's mess

  // setup the new nav
  current_nav = $(this).attr("id");
  $(this).addClass("active");

  $.ajax({
    url: "/newapi/users",
    type: "get",
    beforeSend: function( xhr ) {
      console.log("carregando");
    },
    success: function( data ) {
      console.log(data);
      console.log("carregado!");
    }
  });
}
*/
// --------------------------
// DOCUMENT READY
$(document).ready(function(){
  $( "input[type='checkbox']" ).change(function() {
    $("#search_form").submit();
  });

  //$( "input[type='text']" ).change(function() {
    //$("#fulltext_search_form").submit();
  //});
});
