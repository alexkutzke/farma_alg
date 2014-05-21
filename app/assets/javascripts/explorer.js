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
//= require jquery.ui.all
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
//= require answers_panel/vivagraph
//= require_tree ./explorer/
//= require run_prettify

$(this).scroll(function() {
   if ($(this).scrollTop() > 120){
      $('.sidebar-nav').addClass('sidebar-nav-fixed');
   } else {
      $('.sidebar-nav').removeClass('sidebar-nav-fixed');
   }
});

$(document).ready(function(){
	prettyPrint();
  $("span.label").tooltip();
  $("i[rel='tooltip']").tooltip();
  $(".stats_popover").popover();
});

function diffUsingJS(div_id,label1,txt1,label2,txt2){
    // get the baseText and newText values from the two textboxes, and split them into lines
    base = difflib.stringAsLines(txt1);//$("baseText").value);
    newtxt = difflib.stringAsLines(txt2);//$("newText").value);

    //create a SequenceMatcher instance that diffs the two sets of lines
    sm = new difflib.SequenceMatcher(base, newtxt);

    // get the opcodes from the SequenceMatcher instance
    // opcodes is a list of 3-tuples describing what changes should be made to the base text
    // in order to yield the new text
    opcodes = sm.get_opcodes();
    diffoutputdiv = $("#"+div_id);
    while(diffoutputdiv.firstChild)
      diffoutputdiv.removeChild(diffoutputdiv.firstChild);

    //console.log opcodes

    $(diffoutputdiv).append(diffview.buildView({baseTextLines: base, newTextLines: newtxt, opcodes: opcodes, baseTextName: label1, newTextName: label2, contextSize: 0, viewType: 0 }))
}