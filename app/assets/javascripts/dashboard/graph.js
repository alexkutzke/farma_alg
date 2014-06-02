function getQueryParams(qs) {
    qs = qs.split("+").join(" ");
    var params = {},
        tokens,
        re = /[?&]?([^=]+)=([^&]*)/g;

    while (tokens = re.exec(qs)) {
      if(!params[decodeURIComponent(tokens[1])])
        params[decodeURIComponent(tokens[1])] = []
      
      params[decodeURIComponent(tokens[1])].push(decodeURIComponent(tokens[2]));
    }

    return params;
}

var $_GET = getQueryParams(document.location.search);

var status="normal";
var selectedNode=null;

// ===========================================================
// GRAPH CORE

// graph global vars
var graph = Viva.Graph.graph();
var geom = Viva.Graph.geom();
var renderer;
var graphics;
var nodeSize = 50; // Tamanho em pixels dos vértices
var defs;
var pattern;
var nodes = []

// ----------------------------------------------
// Node draw function
function paintNode(n){
  var color,node;

  node = graph.getNode(n)
  if (node.data.correct)
    color = "green";
  else 
    color = "black";
    
  $("#node-"+n).css('fill',color);
}

function nodeDraw(node){

    var color;
    if (node.data.correct)
      color = "green";
    else 
      color = "black";

    var ui = Viva.Graph.svg('g'),
                  // Create SVG text element with user id as content
                  svgText = Viva.Graph.svg('text').attr('y', '-50px').attr('width','20');

    var 
    txt = Viva.Graph.svg('tspan').attr("x","-25px").attr("dy","1.2em").text(node.data.user.name+" @"+node.data.question.title+"#"+node.data.try_number);
    svgText.append(txt);
   
    var circle = Viva.Graph.svg('circle').attr('r', nodeSize/2)
                                         .attr('fill', color)
                                         .attr('id',"node-"+node.id);    

    //var circle = Viva.Graph.svg('rect').attr('height', nodeSize)
    //                                     .attr('width', nodeSize)
    //                                     .attr('fill',color);     

    ui.append(svgText);
    ui.append(circle);

    conteudo = "<div>";

    for(i=0;i<node.data.tags.length;i++)
      conteudo += "<span rel=\"tooltip\" data-toggle=\"tooltip\" data-placement=\"top\" title data-original-title=\" " + node.data.tags[i].description + "\" class=\"label\"> " + node.data.tags[i].name + "</span>";

    conteudo += "</div>";

    $(circle).data("content",conteudo);
    $(circle).data("original-title","título");
    $(circle).data("trigger","hover");
    $(circle).data("placement","top");
    $(circle).popover({delay: { show: 500, hide: 100 }});

    $(circle).dblclick(function(){
      if(selectedNode){
        paintNode(selectedNode);
      }

      $(this).css("fill","gray");
      status = "selectedNode";
      selectedNode = node.id;
      $("#answer-info").show();
      $("#box-answer-info").css("display","block");
      $("#box-answer-info").removeClass("collapsed-box");
      $("#box-answer-info .box-body").css("display","block");
      $("#answer-info").animate({
        height: $(".wrapper").height()*0.8,
      }, 500);

      $.ajax({
        url: "/dashboard/graph_answer_info/",
        type: "post",
        data: {id:node.id},
        dataType: "script",
        success: function(){
          console.log("OK");
        }
      });
      //var i;

      //for(i=0; i<node.data.similar_answers.length; i++)
      //{
      //  addAnswer(node.data.similar_answers[i]);
      //}
    });

    $(circle).hover(function(){
      if(status == "removeAnswer")
        $(this).css("fill","gray");
    },
    function(){
      if(status != "selectedNode" || selectedNode != node.id){
        paintNode(node.id);
      }
    });

    $(circle).click(function(){
      if(status == "removeAnswer")
        graph.removeNode(node.id);
    });

    return ui;
}

// ----------------------------------------------
// Link draw function
function linkDraw(link){
    // Cria objeto de texto
    //var label = Viva.Graph.svg('text').attr('id','label_'+link.data.id).text('');//link.data.weight);
    
    // Adiciona o objeto de texto ao root svg
    //graphics.getSvgRoot().childNodes[0].append(label);
    
    var edge = Viva.Graph.svg('path')
                .attr('stroke', 'rgb('+Math.floor(255*link.data.weight)+',0,0)')
                .attr('stroke-width',Math.floor(10*link.data.weight))
                .attr('id', link.data.id);

    $(edge).data("content","conteúdo");
    $(edge).data("original-title","título");
    $(edge).data("trigger","hover");
    $(edge).data("placement","top");
    $(edge).popover();

    $(edge).dblclick(function(){
      $(".node_menu").animate({
        left: "+=0",
      }, 500);

      $.ajax({
        url: "/explorer/info_connection/",
        type: "post",
        data: {id:link.data.id},
        dataType: "script",
        success: function(){
          //console.log("OK");
        }
      });
    });

    return edge;
}

// ----------------------------------------------
// Link positioning function
function linkPositioning(linkUI, fromPos, toPos) {
    var toNodeSize = nodeSize,
    fromNodeSize = nodeSize;

    var from = geom.intersectRect(
          fromPos.x - fromNodeSize / 2, // left
          fromPos.y - fromNodeSize / 2, // top
          fromPos.x + fromNodeSize / 2, // right
          fromPos.y + fromNodeSize / 2, // bottom
          fromPos.x, fromPos.y, toPos.x, toPos.y)
          || fromPos;

    var to = geom.intersectRect(
        toPos.x - toNodeSize / 2, // left
        toPos.y - toNodeSize / 2, // top
        toPos.x + toNodeSize / 2, // right
        toPos.y + toNodeSize / 2, // bottom
        // segment:
        toPos.x, toPos.y, fromPos.x, fromPos.y)
        || toPos;

    var data = 'M' + from.x + ',' + from.y + 'L' + to.x + ',' + to.y;

    linkUI.attr("d", data);
  
    // Adiciona o objeto de texto à aresta
    //document.getElementById('label_'+linkUI.attr('id'))
    //                      .attr("x", (from.x + to.x) / 2)
    //                      .attr("y", (from.y + to.y) / 2);
}

// ----------------------------------------------
// Graph draw function
function draw()
{
  graphics = Viva.Graph.View.svgGraphics();

  var layout = Viva.Graph.Layout.forceDirected(graph, {
    springLength: 200 
  });

  // Configuracao inicial do grafo
  renderer = Viva.Graph.View.renderer(graph, {
    layout : layout,
    graphics : graphics,
    container : document.getElementById('graph')
  });

  // Inicia o desenho do grafo
  renderer.run();

  defs = graphics.getSvgRoot().append('defs')
  pattern = defs.append('pattern')

  // Desenha o vertice
  graphics.node(nodeDraw);
  
  // Define a posição do vertice
  graphics.placeNode(function(nodeUI, pos){
    //nodeUI.attr( "cx", pos.x).attr("cy", pos.y);
    nodeUI.attr('transform',
                'translate(' + (pos.x) + ',' + (pos.y) +')');
  });

  // Funcao de desenho das arestas
  graphics.link(linkDraw); // link

  // Posiciona aresta
  graphics.placeLink(linkPositioning); // placeLink
}

function getAnswer(id,beforeSend,success)
{
  $.ajax({
    url: "/newapi/answers/"+id,
    type: "get",
    beforeSend: beforeSend("answer-"+id),
    success: success
  });
}

function getLinks(id,beforeSend,success)
{
  $.ajax({
    url: "/newapi/answers/"+id+"/connections",
    type: "get",
    beforeSend: beforeSend("answer-"+id+"-connections"),
    success: success
  });
}

function defaultBeforeSend(item)
{
  console.log("carregando " + item + " ...");
}

// ===========================================================
// Graph manipulation functions

function getAnswerSuccess(data)
{
  console.log(data);
  console.log("carregado!");

  if(nodes.indexOf(data.id) == -1)
  {
    graph.addNode(data.id,data);
    nodes.push(data.id);
    getLinks(data.id,defaultBeforeSend,getLinksSuccess);
  }
}

function getLinksSuccess(data)
{
  console.log(data);
  console.log("carregado!");

  for(i=0;i<data.length;i++)
  {
    if(nodes.indexOf(data[i].target_answer_id) != -1)
      if(data[i].weight > 0.7)
        graph.addLink(data[i].answer_id, data[i].target_answer_id, {id: data[i].id, weight : data[i].weight});
  }
}

function addAnswer(id)
{
  getAnswer(id,defaultBeforeSend,getAnswerSuccess);
}

// ===========================================================
// DOCUMENT READY
var mouse_x,mouse_y;

$(document).ready(function(){

  resizeApp();

  $( "input[type='checkbox']" ).change(function() {
    $("#search_form").submit();
  });

  //$( "input[type='text']" ).change(function() {
    //$("#fulltext_search_form").submit();
  //});

  $(".menu").hover(
    function() {
          //console.log("="+($(window).height()-$(this).height()).toString());
      $(this).animate({
        top: "+="+($(window).height()-$(this).height()).toString(),
      }, 500);

      
    }, function() {
      $(this).animate({
        top: "+="+($(window).height()-10).toString(),
      }, 500);
    }
  );

  $(".node_menu").on('click','#hide_node_menu',function(){
      $(".node_menu").animate({
        left: "-=300",
      }, 500);
    }
  );
  
  draw();

  $(document).mousemove(function(e){
    mouse_x = e.pageX;
    mouse_y = e.pageY;
  });

  $("#answers").on('click','.addNode',function(){
    addAnswer($(this).data("id"));
  });

  $(".node_menu").on('click','#show_code',function(){
    $(".code-modal-body").modal();

    $(".code-modal-body").height($(window).height() - 50);
    $(".code-modal-body").width($(window).width() - 50);
    $(".code-modal-body").css("top","15px");
    $(".code-modal-body").css("left","15px");
    $(".code-modal-body").css("margin","0");
  });

  $(".node_menu").on('click','#show_diff',function(){
    $(".code-modal-body").modal();
    $(".code-modal-body").height($(window).height() - 50);
    $(".code-modal-body").width($(window).width() - 50);
    $(".code-modal-body").css("top","15px");
    $(".code-modal-body").css("left","15px");
    $(".code-modal-body").css("margin","0");
  });

  $("")


  $( ".menu" ).css("top",($(window).height()-10)+"px");
  $( ".menu" ).resizable({
      maxHeight: $(window).height()-200,
      minHeight: 10,
      handles: "n"
    });

  $("body").on("DOMNodeInserted",".popover", function(){
    var y = mouse_y - $(this).height()-20;
    var x = mouse_x - $(this).width()/2;
    var pop = $(this);
    window.setTimeout(function(){
      $(pop).attr("style","top: " +y+"px;left: "+x+"px; display: block;");
     // console.log($(pop));
    },10);
  });

  $.widget( "ui.autocomplete", $.ui.autocomplete, {
    _renderItem: function(ul,item) {
      return $( "<li>" )
            .attr( "data-value", item.value )
            .append( $( "<a>" ).text( item.label ) )
            .appendTo( ul );
    }
});

  $("[data-toggle='offcanvas']").click(function(){
    resizeApp();
  });

  $(".toolbar-btn").click(function(){
    bar = $(this).parent().find(".toolbar-btn-element");
    if(!bar.hasClass("open")){
      bar.addClass("open");
      bar.animate({width: $(".right-side").width()*0.75},500)
    }
    else{
      bar.removeClass("open");
      bar.animate({width: 0},500) 
    }

  })

  $(".toolbar-btn").hover(
    function(){
      bar = $(this).parent().find(".toolbar-btn-label");
      bar.addClass("open");
      bar.animate({width: 250},500)
    },
    function(){
      bar = $(this).parent().find(".toolbar-btn-label");

      bar.removeClass("open");
      bar.animate({width: 0},500)
    }
  );

  $("input[name='query']").keyup(function(e) {
    e.stopPropagation();
    if (e.keyCode == 27){
      $("#search-result-container").hide();
    }
  });

  $("#remove-answer").click(function(){
    if(status != "removeAnswer"){
      status = "removeAnswer";
      $("body").css("cursor","crosshair");
    }
    else{
     status = "normal";
     $("body").css("cursor","auto");
    }
  });

  $(document).keyup(function(e) {
    if(status == "removeAnswer"){
      if (e.keyCode == 27){
        $("#remove-answer").click();
      }
    }
  });

  $("input[name='query']").focusin(function(e) {
      $("#search-result-container").show();
  });

  $("#graph").click(function(){
    $("#search-result-container").hide();
  });

  $(".toolbar-item").each(function()
  {
    prev = $(this).prev();
    if(prev.hasClass("toolbar-item")){
      pos = parseInt(prev.find(".toolbar-btn").css("top")) + prev.find(".toolbar-btn").height();
      $(this).find(".toolbar-btn").css("top",pos+"px");
      $(this).find(".toolbar-btn-element").css("top",pos+"px");
      $(this).find(".toolbar-btn-label").css("top",pos+"px");
    }
    else{
      $(this).find(".toolbar-btn").css("top",0);
      $(this).find(".toolbar-btn-element").css("top",0);
      $(this).find(".toolbar-btn-label").css("top",0); 
    }
  });

  $("#answer-info").height(0);
  $("#answer-info").hide(0);

  var k,i;
  for (k in $_GET){
    for(i=0;i<$_GET[k].length;i++){
      if(k == "answer_id")
        addAnswer($_GET[k][i]);
    }
  }

  $("#reset-btn").click(function(){
    renderer.reset();
  });
});
