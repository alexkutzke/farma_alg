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
//= require underscore
//= require underscore.string
//= require backbone
//= require backbone.marionette
//= require backbone-relational
//= require backbone.sync.rails
//= require Backbone.ModelBinder
//= require twitter/bootstrap
//= require bootstrap-modalmanager
//= require bootstrap-modal
//= require handlebars
//= require monkeys
//= require carrie
//= require parser
//= require visualsearch
//= require difflib
//= require diffview
//= require codemirror/lib/codemirror
//= require codemirror/mode/pascal/pascal
//= require codemirror/mode/ruby/ruby
//= require codemirror/mode/clike/clike
//= require_tree ./lib
//= require_tree ./templates
//= require_tree ./models
//= require_tree ./collections
//= require_tree ./views
//= require_tree ./routers
//= require_tree ./controllers
//= require_tree ./helpers


$(this).scroll(function() {
   if ($(this).scrollTop() > 120){
      $('.sidebar-nav').addClass('sidebar-nav-fixed');
   } else {
      $('.sidebar-nav').removeClass('sidebar-nav-fixed');
   }
});
