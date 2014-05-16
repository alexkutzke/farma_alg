// ===========================================================
// GRAPH CORE

// graph global vars
var graph = Viva.Graph.graph();
var geom = Viva.Graph.geom();
var renderer;
var graphics;
var nodeSize = 24; // Tamanho em pixels dos vértices
var defs;
var pattern;
var nodes = []

// ----------------------------------------------
// Node draw function
function nodeDraw(node){

    var color;
    if (node.data.correct)
      color = "green";
    else 
      color = "black";

    console.log(color);
    console.log(node.data.correct);

    var circle = Viva.Graph.svg('circle').attr('r', nodeSize/2)
                                         .attr('fill', color);     
    $(circle).click(function(){
      $(".node_menu").animate({
        left: "+=0",
      }, 500);

      $.ajax({
        url: "/explorer/info_answer/",
        type: "post",
        data: {id:node.id},
        dataType: "script",
        success: function(){
          console.log("OK");
        }
      });
    });

    return circle;
}

// ----------------------------------------------
// Link draw function
function linkDraw(link){
    // Cria objeto de texto
    var label = Viva.Graph.svg('text').attr('id','label_'+link.data.id).text('');//link.data.weight);
    
    // Adiciona o objeto de texto ao root svg
    graphics.getSvgRoot().childNodes[0].append(label);
    
    return Viva.Graph.svg('path')
                .attr('stroke', 'gray')
                .attr('stroke-width',link.data.weight*10)
                .attr('id', link.data.id);
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
    document.getElementById('label_'+linkUI.attr('id'))
                          .attr("x", (from.x + to.x) / 2)
                          .attr("y", (from.y + to.y) / 2);
}

// ----------------------------------------------
// Graph draw function
function draw()
{
  graphics = Viva.Graph.View.svgGraphics(),

  // Configuracao inicial do grafo
  renderer = Viva.Graph.View.renderer(graph, {
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
    nodeUI.attr( "cx", pos.x).attr("cy", pos.y);
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
      graph.addLink(data[i].answer_id, data[i].target_answer_id, {id: data[i].id, weight : data[i].weight});
  }
}

function addAnswer(id)
{
  getAnswer(id,defaultBeforeSend,getAnswerSuccess);
}

function nodeClick(node)
{

}

// ===========================================================
// DOCUMENT READY

$(document).ready(function(){
  $( "input[type='checkbox']" ).change(function() {
    $("#search_form").submit();
  });

  //$( "input[type='text']" ).change(function() {
    //$("#fulltext_search_form").submit();
  //});

  $(".menu").hover(
    function() {
      $(this).animate({
        bottom: "+=0",
      }, 500);

      
    }, function() {
      $(this).animate({
        bottom: "-=295",
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
});
