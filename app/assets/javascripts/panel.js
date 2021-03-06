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
//= require prettify
//= require lang-pascal
//= require bootbox.min
//= require ckeditor/init
//= require jquery_ckeditor_adapter
//= require twitter/bootstrap
//= require bootstrap-modalmanager
//= require bootstrap-modal
//= require difflib
//= require diffview
//= require codemirror/lib/codemirror
//= require codemirror/mode/pascal/pascal
//= require codemirror/mode/ruby/ruby
//= require codemirror/mode/clike/clike
//= require_tree ./panel/

$(this).scroll(function() {
   if ($(this).scrollTop() > 120){
      $('.sidebar-nav').addClass('sidebar-nav-fixed');
   } else {
      $('.sidebar-nav').removeClass('sidebar-nav-fixed');
   }
});

$(document).ready(function(){
	$("span.label").tooltip();
  $("i[rel='tooltip']").tooltip();
  $(".stats_popover").popover();

//  $(".stats_popover").hover(function(){
//    $(this).popover('toggle');
//  });

  $("#comments_link").click(function(ev){
    ev.preventDefault();
    $("#comments").slideToggle();
  });

  $("#enrolled_link").click(function(ev){
    ev.preventDefault();
    $("#enrolled").slideToggle();
  });

  $("#my_teams_link").click(function(ev){
    ev.preventDefault();
    $("#my_teams").slideToggle();
  });

  $("#others_teams_link").click(function(ev){
    ev.preventDefault();
    $("#others_teams").slideToggle();
  });

  $(".stats_link").click(function(ev){
    ev.preventDefault();
    $("#stats_"+$(this).data("question-id")).slideToggle();
  });
});
