var selectedUserId = null;

function answerShowCallback(){

}

function searchResultCallback(){
}

function addUser(item){
	$("<li>").data("id",item.value[1]+"-"+item.value[0])
					 .append(item.label)
					 .append(" <span class='label label-danger remove-item' style='cursor:pointer;'><i class='fa fa-times'></i></span>")
					 .appendTo($("#users"));
}

function addAnswer(data){
  $("<li>").data("id","answer_id-"+data.id)
           .append(data.user.name+ " @ "+data.question.title + " #"+data.try_number)
           .append(" <span class='label label-danger remove-item' style='cursor:pointer;'><i class='fa fa-times'></i></span>")
           .append(" <span class='label label-default answer-btn' style='cursor:pointer;' data-id="+data.id+"><i class='fa fa-eye'></i></span>")
           .appendTo($("#answers")); 

  $("<input>").attr("type","hidden")
              .attr("value",data.id)
              .attr("id","answer_id-"+data.id)
              .attr("name","message[answer_ids][]")
              .appendTo($("#message-form"));
}

function visualStuff(){
	resizeApp();

	$.widget( "ui.autocomplete", $.ui.autocomplete, {
    _renderItem: function(ul,item) {
      return $( "<li>" )
            .attr( "data-value", item.value )
            .append( $( "<a>" ).text( item.label ) )
            .appendTo( ul );
    }
  });

	$( "#users-text-field" ).autocomplete({
  	source: availableUsers,
  	focus: function( event, ui ) {
  		event.preventDefault();
  		$("#users-text-field").val(ui.item.label);},
  	select: function(event,ui){
  		event.preventDefault();
  		selectedUserId = ui.item;
  		$("#users-text-field").val(ui.item.label);
  	}
	});
}

function bindClicks(){
	$("#close-answers-btn").click(function(){
		$("#add-answers").slideUp();
	});

	$("#open-answers-btn").click(function(e){
		e.preventDefault();
		$("#add-answers").slideDown();
		$("#add-questions").slideUp();
		correctFiltersPosition();
	});

	$("#close-questions-btn").click(function(){
		$("#add-questions").slideUp();
	});

	$("#open-questions-btn").click(function(e){
		e.preventDefault();
		$("#add-questions").slideDown();
		$("#add-answers").slideUp();
	});

	$("#add-users-btn").click(function(e){
		e.preventDefault();

		elem = $("<input>").attr("type","hidden")
											 .attr("value",selectedUserId.value[0]);

		if(selectedUserId.value[1] == "user_id"){
			elem.attr("name","message[user_ids][]")
					.attr("id","user_id-"+selectedUserId.value[0]);
		}
		else{
			elem.attr("name","message[team_ids][]")
					.attr("id","team_id-"+selectedUserId.value[0]);
		}
		
		if(!$("input#"+selectedUserId.value[1]+"-"+selectedUserId.value[0]).length){
			elem.appendTo($("#message-form"));
			addUser(selectedUserId);
		}

		$("#users-text-field").val('');
	});

	$(".content").on("click",".remove-item",function(){
		li = $(this).parent();
		$("#"+li.data("id")).remove();
		li.remove();
	});

  $("#answers").on("click",".answer-btn",function(){
    $.ajax({
      url: "/dashboard/answers/show",
      data: {
        id: $(this).data("id")
      },
      type: "get"    
    });
  });

  $("#search_result").on("click",".add_answer_link",function(){

    if(!$("input#answer_id-"+$(this).data("answer-id")).length){
      $.ajax({
        url: "/newapi/answers/"+$(this).data("answer-id"),
        type: "get",
        success: function(data){
          addAnswer(data);
        }
      });
    }
  });
}

$(document).ready(function(){
	bindClicks();

	visualStuff();
});