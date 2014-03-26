
var code = 0;

$(document).ready(function(){

  $(".virtual-keyboard").modal({show: false});

  $("#send_answer").click(function(ev){
    ev.preventDefault();

    data = {'response': code.getValue()};

    $.ajax({
      type: "POST",
      url: "/api/answers/"+$(this).data("id")+"/retroaction",
      data: data,
      dataType: "script"
    });

    $(".virtual-keyboard").modal('hide');
    bootbox.modal("Compilando e executando ...",{backdrop:'static',keyboard:false});
  });

	$(document).on('click','#try_again',function(ev){
		ev.preventDefault();

    if(code == 0){
      c = $('#code');
      code = CodeMirror(c[0], { value: "", mode: $(this).data("lang"),  tabSize:2, lineNumbers: true });
    }
    else{
      code.setValue($(this).data("resp"));
    }

    setTimeout(function(){
      self.code.refresh();
      self.code.focus();
      self.code.setSize('100%','450');
    }, 100);
    $(".virtual-keyboard").modal('show');
	});

});

