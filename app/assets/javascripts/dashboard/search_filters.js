function correctFiltersPosition(){
  if(! $(".right-side-body").hasClass("open")){
    $(".right-side-body").animate({right: -$(".right-side-body").width()-2},500);
    $(".right-side-button").css("right",0);
  }
  else{
    $(".right-side-body").animate({right: 0},500);
    $(".right-side-button").css("right",$(".right-side-body").width());
  }
}

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

  $(".right-side-body").css("right",-$(".right-side-body").width());

  $("form").on("click",".filters-btn", function(ev){
    ev.preventDefault();
    if(! $(".right-side-body").hasClass("open")){
      $(".right-side-body").addClass("open")
      $(".right-side-body").animate({right: 0},500);
      $(".right-side-button").css("right",$(".right-side-body").width());
    }
    else{
      $(".right-side-body").removeClass("open")
      $(".right-side-body").animate({right: -$(".right-side-body").width()-2},500);
      $(".right-side-button").css("right",0);
    }
  });

  $(window).resize(function(){
    correctFiltersPosition();
  });

  correctFiltersPosition();

  $( ".checkbox" ).on("ifChanged","input[type='checkbox']",function() {
    $("#search-result").html("");
    $("#search-form").submit();
  });

  $("#filters").on("click","#filters-close-btn",function(){
    if($(".right-side-body").hasClass("open")){
      $(".right-side-body").removeClass("open")
      $(".right-side-body").animate({right: -$(".right-side-body").width()-2},500);
      $(".right-side-button").css("right",0);
    }
  });
});


var trapScroll;

(function($){

trapScroll = function(opt){

var trapElement;
var scrollableDist;
var trapClassName = 'trapScroll-enabled';
var trapSelector = '.trapScroll';


var trapWheel = function(e){

  if (!$('body').hasClass(trapClassName)) return;
  else {
    var curScrollPos = trapElement.scrollTop();
    var wheelEvent = e.originalEvent;
    var dY = wheelEvent.deltaY;

    // only trap events once we've scrolled to the end
    // or beginning
    if ((dY>0 && curScrollPos >= scrollableDist) ||
        (dY<0 && curScrollPos <= 0)) {

      opt.onScrollEnd();
      return false;
    }
  }
}

$(document)
  .on('wheel', trapWheel)
  .on('mouseleave', trapSelector, function(){

    $('body').removeClass(trapClassName);
  })
  .on('mouseenter', trapSelector, function(){
    trapElement = $(this);
    var containerHeight = trapElement.outerHeight();
    var contentHeight = trapElement[0].scrollHeight; // height of scrollable content
    scrollableDist = contentHeight - containerHeight;

    if (contentHeight>containerHeight)
      $('body').addClass(trapClassName);
  });
}
})($);

$(document).ready(function(){
    trapScroll({ onScrollEnd: function(){} });
})
