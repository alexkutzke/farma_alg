function diffUsingJS(answer_id,resp1,resp2){
    // get the baseText and newText values from the two textboxes, and split them into lines
    base = difflib.stringAsLines(resp1);//$("baseText").value);
    newtxt = difflib.stringAsLines(resp2);//$("newText").value);

    //create a SequenceMatcher instance that diffs the two sets of lines
    sm = new difflib.SequenceMatcher(base, newtxt);

    // get the opcodes from the SequenceMatcher instance
    // opcodes is a list of 3-tuples describing what changes should be made to the base text
    // in order to yield the new text
    opcodes = sm.get_opcodes();
    diffoutputdiv = $("#"+answer_id);
    while(diffoutputdiv.firstChild)
      diffoutputdiv.removeChild(diffoutputdiv.firstChild);

    //console.log opcodes

    $(diffoutputdiv).append(diffview.buildView({baseTextLines: base, newTextLines: newtxt, opcodes: opcodes, baseTextName: "Resposta", newTextName: "Resposta anterior", contextSize: 0, viewType: 0 }))
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
	   diffUsingJS($(this).data("id"),$(this).data("response"),$(this).data("previous"));
	});

  $("#markdown_link").click(function(ev){
    ev.preventDefault();
    $("#markdown_examples").toggle();
  });

  $('.change_correctness').popover();
});