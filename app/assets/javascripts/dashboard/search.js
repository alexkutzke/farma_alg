var timeout = null;

function doSubmitQuery()
{
  $("#search_result").html("");
  $("#search-form").submit();
}

function submitQuery(n){
  if(timeout)
  {
    clearTimeout(timeout);
  }
  timeout = setTimeout(doSubmitQuery, n);
}