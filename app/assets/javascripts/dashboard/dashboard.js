// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery.md5
//= require AdminLTE/bootstrap
//= require AdminLTE/AdminLTE/app
//= require_self

var comecei = 0;
  $(document).ajaxSend(function(){
    comecei +=1;
    if(comecei == 1)
    {
      $("body").addClass("pace-running");
      $("body").removeClass("pace-done");
      $(".pace").removeClass("pace-inactive");
      $(".pace").addClass("pace-active");
    }
  });

  $(document).ajaxComplete(function(){
    comecei -=1;
    if(!comecei)
    {
      $("body").removeClass("pace-running");
      $("body").addClass("pace-done");
      $(".pace").addClass("pace-inactive");
      $(".pace").removeClass("pace-active");
    }
  });