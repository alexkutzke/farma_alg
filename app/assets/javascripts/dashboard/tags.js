var selectedTagId = null;

var myApp;
myApp = myApp || (function () {
    var pleaseWaitDiv = $('<div class="modal hide" id="pleaseWaitDialog" data-backdrop="static" data-keyboard="false"><div class="modal-header"><h1>Processing...</h1></div><div class="modal-body"><div class="progress progress-striped active"><div class="bar" style="width: 100%;"></div></div></div></div>');
    return {
        showPleaseWait: function() {
            pleaseWaitDiv.modal();
        },
        hidePleaseWait: function () {
            pleaseWaitDiv.modal('hide');
        },

    };
})();

function answerShowCallback(){

}

function searchResultCallback(){
	myApp.hidePleaseWait();
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

		$(".tags-header").html($(this).html()+"<small>"+$(this).data("original-title")+"</small>");

		selectedTagId = $(this).data("id");

		$("#tags-filter input[type='checkbox']").iCheck('uncheck');
		$("#tags-filter input:checkbox[value="+selectedTagId+"]").iCheck('check');
		myApp.showPleaseWait();

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