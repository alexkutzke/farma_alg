// Get the GET params
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

// Status vars
var status="normal";
var selectedNode=null;
var selectedEdge=null;
var firstNode=null;
var secondNode=null;
var running=true;
var new_links = [];

function makeLink(){
  var params="?";

  graph.forEachNode(function(node){
    params += "answer_id=" + node.id + "&";
  });

  return(document.URL+params);
}

function answerShowCallback(){
  $("#close-answer-info").click(function(){
    if(selectedNode)
    {
      paintNode(selectedNode);
      selectedNode = null;
    }
    if(selectedEdge)
    {
      paintEdge(selectedEdge);
      selectedNode = null;
    }
  });
}

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
var links2 = []

// ----------------------------------------------
// Node draw function
function paintNode(n){
  var color,node;

  node = graph.getNode(n)
  if (node.data.correct)
    color = "green";
  else if (node.data.compile_errors)
    color = "orange";
  else
    color = "black";

  $("#node-"+n).css('fill',color);
}

function nodeDraw(node){

    var color;
  if (node.data.correct)
    color = "green";
  else if (node.data.compile_errors)
    color = "orange";
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

      if(selectedEdge){
        paintEdge(selectedEdge);
      }

      $(this).css("fill","yellow");
      status = "selectedNode";
      selectedNode = node.id;
/*
      $("#answer-info").show();
      $("#box-answer-info").css("display","block");
      $("#box-answer-info").removeClass("collapsed-box");
      $("#box-answer-info .box-body").css("display","block");
      $("#answer-info").animate({
        height: $(".wrapper").height()*0.8,
      }, 500);
*/
      $.ajax({
        url: "/dashboard/answers/show?graph=true",
        type: "get",
        data: {id:node.id},
        dataType: "script",
        success: function(){
        //  console.log("OK");
        }
      });
    });

    $(circle).hover(
      function(){
      if(status == "removeAnswer"){
        $(this).css("fill","red");
      }
      else if(status == "addEdge"){
        $(this).css("fill","red");
      }
    },
      function(){
        if((status != "selectedNode" && status != "addEdge") || (selectedNode != node.id && firstNode != node.id && secondNode != node.id)){
          paintNode(node.id);
        }
      }
    );

    $(circle).click(function(){
      if(status == "removeAnswer"){
        graph.removeNode(node.id);
      }
      else if(status == "addEdge"){
        if(!firstNode){
          firstNode = node.id;
          $(this).css("fill","yellow");
        }
        else{
          secondNode = node.id;
          $(this).css("fill","yellow");
          addEdge(firstNode,secondNode);
        }
      }
    });

    return ui;
}

// ----------------------------------------------
// Link draw function
function paintEdge(e){
  var color;

  color = 'rgb('+Math.floor(255*parseFloat($("#edge-"+e).data("weight")))+',0,0)';

  $("#edge-"+e).attr('stroke',color);
}

function linkDraw(link){
    var edge = Viva.Graph.svg('path')
                .attr('stroke', 'rgb('+Math.floor(255*link.data.weight)+',0,0)')
                .attr('stroke-width',Math.floor(10*link.data.weight))
                .attr('id', "edge-"+link.data.id)
                .attr('data-weight', link.data.weight);

    $(edge).data("content","conteúdo");
    $(edge).data("original-title","título");
    $(edge).data("trigger","hover");
    $(edge).data("placement","top");
    $(edge).popover();

    $(edge).dblclick(function(){
      if(selectedNode){
        paintNode(selectedNode);
      }

      if(selectedEdge){
        paintEdge(selectedEdge);
      }

      $("#edge-"+link.data.id).attr('stroke',"yellow");

      selectedEdge = link.data.id;
/*
      $("#answer-info").show();
      $("#box-answer-info").css("display","block");
      $("#box-answer-info").removeClass("collapsed-box");
      $("#box-answer-info .box-body").css("display","block");
      $("#answer-info").animate({
        height: $(".wrapper").height()*0.8,
      }, 500);

      $(".node_menu").animate({
        left: "+=0",
      }, 500);
*/
      $.ajax({
        url: "/dashboard/connections/show",
        type: "get",
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
//  console.log(data);
//  console.log("carregado!");

  if(nodes.indexOf(data.id) == -1)
  {
    graph.addNode(data.id,data);
    nodes.push(data.id);
    getLinks(data.id,defaultBeforeSend,getLinksSuccess);
  }
}

function getLinksSuccess(data)
{
//  console.log(data);
//  console.log("carregado!");

  for(i=0;i<data.length;i++)
  {
    if(nodes.indexOf(data[i].target_answer_id) != -1)
      //if(data[i].weight > 0.7)
      links2.push(graph.addLink(data[i].answer_id, data[i].target_answer_id, {id: data[i].id, weight : data[i].weight}));
  }
}

function  removeEdges(data){

  graph.forEachLink(function(link){
    if(link.data.id == data[0].id)
    {
      graph.removeLink(link);
    }
  });

  graph.forEachLink(function(link){
    if(link.data.id == data[1].id )
    {
      graph.removeLink(link);
    }
  });
}

function link_thres(thres_par)
{
  //var thres = parseFloat($("#thres2").val());
  var thres = thres_par;

  new_links = [];

  var i;
  for(i=0;i<links2.length;i++)
  {
    graph.removeLink(links2[i]);
    if(parseFloat(links2[i].data.weight) >= thres_par)
      links2[i] = graph.addLink(links2[i].fromId,links2[i].toId,links2[i].data);
  }

  //graph.forEachLink(function(link){
    //if(parseFloat(link.data.weight) < thres)
    //  graph.removeLink(link);
  //});

}

function addAnswer(id)
{
  getAnswer(id,defaultBeforeSend,getAnswerSuccess);
}

function addEdgeSuccess(data)
{
  $("#add-edge").click();
  links2.push(graph.addLink(data.answer_id, data.target_answer_id, {id: data.id, weight : data.weight}));
}

function addEdge(node1_id,node2_id)
{
  if(node1_id == node2_id)
    return(false);
  $.ajax({
    url: "/newapi/connections/",
    type: "post",
    data:{
      answer1_id: node1_id,
      answer2_id: node2_id
    },
    beforeSend: defaultBeforeSend("add-connections"),
    success: addEdgeSuccess
  });
}

function addGroupLinks(data){
  var i;

  for(i=0;i<data.length;i++)
  {
    if(nodes.indexOf(data[i].target_answer_id) != -1)
      //if(data[i].weight > 0.7)
      links2.push(graph.addLink(data[i].answer_id, data[i].target_answer_id, {id: data[i].id, weight : data[i].weight}));
  }
  bootbox.hideAll();
}

function addGroupNodes(data){
  var i;
  var ids;
  ids = [];

  //console.log(data);

  for(i=0;i<data.length;i++){
    graph.addNode(data[i].id,data[i]);
    nodes.push(data[i].id);
    ids.push(data[i].id)
  }

  $.ajax({
    url: "/newapi/answers/connections",
    type: "post",
    data: {answer_ids: ids},
    success: addGroupLinks
  });
}

function show_bootbox(msg){
  bootbox.dialog({title:"Processando", message: msg, backdrop:'static',onEscape:false,closeButton:false});
}

function addGroup(answer_ids){
  show_bootbox("Carregando respostas...");
  $.ajax({
    url: "/newapi/answers/group",
    type: "post",
    data: {answer_ids: answer_ids},
    success: addGroupNodes
  });
}

function addConnectedComponent(id){
  show_bootbox("Calculando componente conexa e carregando respostas...");
  $.ajax({
    url: "/newapi/answers/"+id+"/connected_component",
    type: "get",
    success: addGroupNodes
  });
}

function addSimilar(id){
  show_bootbox("Carregando respostas...");
  $.ajax({
    url: "/newapi/answers/"+id+"/similar",
    type: "get",
    success: addGroupNodes
  });
}

// ===========================================================
// DOCUMENT READY
var mouse_x,mouse_y;

$(document).ready(function(){

  // Initialize functions
  resizeApp();
  draw();

  $("#thres2").val("0.0");
  //$("#answer-info").height(0);
  //$("#answer-info").hide(0);

  //$("#answer-show").css("top",($('.header').height()+$('.content-header').height()+48)+"px")

  var k,i;
  var answer_ids=[];
  for (k in $_GET){
    for(i=0;i<$_GET[k].length;i++){
      if(k == "answer_id")
        answer_ids.push($_GET[k][i]);
      else if(k == "connected_component")
        addConnectedComponent($_GET[k][i]);
      else if(k == "similar")
        addSimilar($_GET[k][i]);
    }
  }

  if(answer_ids.length > 0)
    addGroup(answer_ids);

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
      bar.animate({width: 300},500)
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

  $("#add-edge").click(function(){
    if(status != "addEdge"){
      status = "addEdge";
      firstNode = null;
      secondNode = null;
      $("body").css("cursor","crosshair");
    }
    else{
     status = "normal";
     if(firstNode)
      paintNode(firstNode);

     if(secondNode)
      paintNode(secondNode);

     firstNode = null;
     secondNode = null;
     $("body").css("cursor","auto");
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
    if(status == "addEdge"){
      if (e.keyCode == 27){
        $("#add-edge").click();
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

  $("#reset-btn").click(function(){
    renderer.reset();
  });

  $("#pause-btn").click(function(){
    if(running){
      renderer.pause();
      running = false;
    }
    else{
      renderer.resume();
      running = true;
    }
  });

  $("#link-btn").click(function(){
    $("#link-span").html(makeLink());
  });

  $("#clean-btn").click(function(){
    graph.forEachNode(function(node){
      graph.removeNode(node.id);
    });

//    renderer.stop();
//    renderer.start();
  });

  // Other stuff
  $(document).mousemove(function(e){
    mouse_x = e.pageX;
    mouse_y = e.pageY;
  });

  $( "#slider" ).slider({orientation: "vertical", value: 40.0});
  $( "#slider" ).on( "slidechange", function( event, ui ) { link_thres(ui.value/100.0)} );
  $( "#slider" ).on( "slide", function( event, ui ) { $("#slider_value").html(ui.value + "%")} );
  $("#slider_value").html("40%");

});
