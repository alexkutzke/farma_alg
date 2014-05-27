var timeout = null;

function doSubmitQuery()
{
  $("#search_result").html("");
  $("#search-form").submit();
}

function submitQuery(n){
  if(timeout)
  {
    clearTimeout(timeout);
  }
  timeout = setTimeout(doSubmitQuery, n);
}

$( "input[type=text]" ).keypress(function() {
  submitQuery(500);
});

$(document).ready(function(){
  //Date range as a button
  $('input[name="daterange"]').daterangepicker(
          {
              locale: {
                  applyLabel: 'Aplicar',
                  cancelLabel: 'Cancelar',
                  fromLabel: 'De',
                  toLabel: 'Até',
                  weekLabel: 'S',
                  customRangeLabel: 'Outro intervalo',
                  daysOfWeek: ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"],
                  monthNames: ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"],
                  firstDay: 0
              },
              timePicker: true, 
              timePickerIncrement: 10, 
              format: 'DD/MM/YYYY HH:mm',
              ranges: {
                  'Hoje': [moment().startOf('day'), moment().endOf('day')],
                  'Ontem': [moment().subtract('days', 1).startOf('day'), moment().subtract('days', 1).endOf('day')],
                  'Últimos 7 dias': [moment().subtract('days', 6).startOf('day'), moment().endOf('day')],
                  'Úlitmos 30 dias': [moment().subtract('days', 29).startOf('day'), moment().endOf('day')],
                  'Este mês': [moment().startOf('month').startOf('day'), moment().endOf('month').endOf('day')],
                  'Último mês': [moment().subtract('month', 1).startOf('month').startOf('day'), moment().subtract('month', 1).endOf('month').endOf('day')]
              },
              startDate: moment().subtract('days', 29),
              endDate: moment()
          },
          function(start, end) {
            $('#reportrange').html(' = ' + start.format('DD/MM/YYYY HH:mm') + ' - ' + end.format('DD/MM/YYYY HH:mm'));
          }
  );
});

$('input[name="daterange"]').on('apply.daterangepicker', function(ev, picker) {
  submitQuery(10);
});