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

$(document).ready(function(){
  $(".question-content-link").click(function(ev){
    ev.preventDefault();
    $("#question-content").slideToggle();
  });

	$(".last-answers-link").click(function(ev){
		ev.preventDefault();
  	$("#accordion_code_"+$(this).data("id")).toggle();
	});

	$('.details-answer-link').click(function(ev){
		ev.preventDefault();
    $("#details_answer_"+$(this).data('id')).toggle();
	});

	$("div.response").each(function(){
     diffUsingJS("response-"+$(this).data("id"),"Resposta",$(this).data("response"),"Resposta anterior",$(this).data("previous"));
	});

  $("div.output").each(function(){
     diffUsingJS($(this).data("id"),"Saída esperada",String($(this).data("expected")),"Saída obtida",String($(this).data("obtained")));
  });

  $("#markdown_link").click(function(ev){
    ev.preventDefault();
    $("#markdown_examples").toggle();
  });

  $('.change_correctness').popover();

  $(".test-case-details").click(function(ev){
    ev.preventDefault();
    $("#test_case_details_"+$(ev.target).data('tcid')+"_"+$(ev.target).data('aid')).slideToggle()
  });
});
