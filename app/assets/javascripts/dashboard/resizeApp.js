function resizeApp()
{
  $(".resize").each(function(index)
  {
    var opt_height = $(this).data('resize-operation-height');
    var opt_width = $(this).data('resize-operation-width');

    if(opt_height != "")
    {
      $(this).height(eval(opt_height));
    }
    if(opt_width != "")
    {
      $(this).width(eval(opt_width));
    }
  });
}

$(window).resize(function() {
  resizeApp();
});