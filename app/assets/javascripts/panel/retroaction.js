
var code;

$(document).ready(function(){

  c = $('#code');
  code = CodeMirror(c[0], { value: "", mode: $(this).data("lang"),  tabSize:2, lineNumbers: true });
  $(".virtual-keyboard").modal({show: false});

  $("#send_answer").click(function(ev){
    ev.preventDefault();

    data = {'response': code.getValue()};

    console.log(data);

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

    code.setValue($(this).data("resp"));

    setTimeout(function(){
      self.code.refresh();
      self.code.focus();
      self.code.setSize('100%','450');
    }, 100);
    $(".virtual-keyboard").modal('show');
	});

});

