var timeout = null;

function submitQuery()
{
  $("#search_result").html("");
  $("#search-form").submit();
}

$( "#search-form .input" ).keypress(function() {
  if(timeout)
  {
    clearTimeout(timeout);
  }
  timeout = setTimeout(submitQuery, 500);
});