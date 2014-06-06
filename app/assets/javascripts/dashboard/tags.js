var selectedTagId = null;

function answerShowCallback(){

}

function searchResultCallback(){
}

function visualStuff(){
	$("#tags-filter").hide();

	correctFiltersPosition();
	resizeApp();
}

function bindClicks(){
	// tag buttons
	$(".tags").click(function(){
		$("#search_result").html("Carregando ...");

		$(".tags").css("border","");
		$(this).css("border","3px solid blue");

		$(".tags-header").html($(this).html()+"<small> "+$(this).data("original-title")+"</small>");

		selectedTagId = $(this).data("id");

		$("#tags-filter input[type='checkbox']").iCheck('uncheck');
		$("#tags-filter input:checkbox[value="+selectedTagId+"]").iCheck('check');

		console.log($("#tags-filter input:checkbox[value="+selectedTagId+"]"));

		$("#tags-body").fadeIn();
		correctFiltersPosition();
		resizeApp();
	});
}

$(document).ready(function(){
	bindClicks();

	visualStuff();
});