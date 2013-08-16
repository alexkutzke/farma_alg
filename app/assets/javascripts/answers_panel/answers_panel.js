var infoOpen=false;
var graph;
var data;
var renderer;

function simpleFormat(str) {
  str = str.replace(/\r\n?/, "\n");
  str = $.trim(str);
  if (str.length > 0) {
    str = str.replace(/\n\n+/g, '</p><p>');
    str = str.replace(/\n/g, '<br />');
    str = '<p>' + str + '</p>';
  }
  return str;
}

function drawEdges(degree)
{
	var l;
	for (i = 0; i < data[0].length; ++i){
		for(var j = 0; j<data[0].length; j++){
			l = graph.hasLink(i,j);
			if(l)
				graph.removeLink(l);
		}
	}

	for (i = 0; i < data[0].length; i++){
		j = 0;
		neigh = data[0][i].neigh;
		while(j < neigh.length && neigh[j][1] >= degree)
		{
			graph.addLink(i,neigh[j][2],neigh[j][1]);
			j++;
		}
	}

	Viva.Graph.community().slpa(graph, 60, 0.30); 

}

function showInfo(node)
{
	if(!infoOpen)
	{
		$("#info").fadeIn();
		infoOpen = true;
	}

	var n=0;
	for (var i = 0; i < data[0].length; i++)
		if(graph.hasLink(node.id,i))
			n++;	

	$("#compile_errors").html("");
	$("#response").html(n+" respostas similares<br>"+simpleFormat(node.data.response));
	$("#correct").html(node.data.correct ? "Sim" : "Não");

	if(node.data.compile_errors)
	{
		$("#compile_errors").html("<h4>Erro de compilação</h4>");
		$("#compile_errors").append(simpleFormat(node.data.compile_errors));
	}
}


function draw(data2)
{
	graph = Viva.Graph.graph();
	data = data2;
	console.log(data)

	var colors = [
	"#1f77b4", "#aec7e8",
	"#ff7f0e", "#ffbb78",
	"#2ca02c", "#98df8a",
	"#d62728", "#ff9896",
	"#9467bd", "#c5b0d5",
	"#8c564b", "#c49c94",
	"#e377c2", "#f7b6d2",
	"#7f7f7f", "#c7c7c7",
	"#bcbd22", "#dbdb8d",
	"#17becf", "#9edae5"
	];

	var layout = Viva.Graph.Layout.forceDirected(graph,{
		springLength : 200,
		springCoeff : 0.0001,
		dragCoeff : 0.09,
		gravity : -1.2,
		thetaCoeff: 1
	});

	var svgGraphics = Viva.Graph.View.svgGraphics();

	renderer = Viva.Graph.View.renderer(graph, {
			container : document.getElementById('graph'),
			layout : layout,
			graphics : svgGraphics,
    		prerender: 1000,
    	//renderLinks : true
   });

	var highlightRelatedNodes = function(nodeId, isOn) {
            // just enumerate all realted nodes and update link color:
            graph.forEachLinkedNode(nodeId, function(node, link){
                if (link && link.ui) {
                    // link.ui is a special property of each link
                    // points to the link presentation object.
                    link.ui.attr('stroke', isOn ? 'red' : 'gray');
                }
            });
        }

	//var layout = Viva.Graph.Layout.forceDirected(graph,{
	//	springLength : 100,
	//	springCoeff : 0.0008,
	//	dragCoeff : 0.8,
	//	gravity : -15.2
	//});

	var npos = [{x:10,y:10}];

	for (var i = 0; i < data[0].length; ++i){
		graph.addNode(i, data[0][i]);
	}

	drawEdges(0.9);

/*
	for (i = 0; i < data[1].length; ++i){
		for(var j = 0; j<data[1].length; j++){
			if (data[1][i][j] > 0.7)
				graph.addLink(i,j,data[1][i][j]);
		}
	}
*/
	//layout.placeNode(function(node) {
	//	return {x:Math.random()*200, y:Math.random()*200};
	//});
	
   
	svgGraphics.node(function(node){
	var groupId = node.communities[0].name % colors.length;
	var colorId = groupId % colors.length;
    var color = colors[colorId ? colorId - 1 : 5];

    if(node.data.correct)
    	color = colors[0];
    else if(node.data.compile_errors)
    	color = colors[2];
    else
    	color = colors[1];
    //console.log(groupId);
    var circle = Viva.Graph.svg('circle')
    .attr('r', 15)
    .attr('stroke', node.data.correct ? "#000" :'#fff')
    .attr('stroke-width', '1.5px')
    .attr("fill", color) 
    .attr("data-toggle","popover")
    .attr("data-placement","left")
    .attr("title","")
    .attr("data-original-title",node.data.created_at)
    .attr("data-content","<pre class=\"prettyprint lang-pascal\">"+node.data.response+"</pre><pre>"+node.data.compile_errors+"</pre>")
    .attr("class","node");

	//	if(node.id === groupId){
					if(Math.random() > 0.5)
            node.isPinned = true;
            //circle.attr('fill', color)
            //    .attr('stroke', 'yellow')
            //    .attr('stroke-width', 3);

    //    }

    //node.isPinned = true;

 		 //circle.append('title').text(node.data.name);

  	$(circle).hover(function() {
  		//$(this).popover().popover("show");
  		highlightRelatedNodes(node.id, true);
  		$(this).attr("stroke","red");
  		$(this).attr("fill","red");
  	},function() {
  		//$(this).popover().popover("hide");
  		highlightRelatedNodes(node.id, false);
  		$(this).attr("stroke","white");
  		$(this).attr("fill",color);//node.data.correct ? colors[1] : colors[2]);
  	});

	$(circle).click(function(){
		showInfo(node);
	});
  	return circle;
	})
	.placeNode(function(nodeUI, pos){
		nodeUI.attr( "cx", pos.x).attr("cy", pos.y);
	});



	svgGraphics.link(function(link){
		x = ((link.data*100)%10)/5;
		var e = Viva.Graph.svg('line')
		.attr('stroke', '#999')
		.attr('stroke-width', x == 0 ? 5 : x);

		if(link.data == 1)
			e.attr("stroke-dasharray","5,5");

		return e;
	});

	renderer.run(2);
	//renderer.pause();



	prettyPrint();
}

$(document).ready(function(){
	$("#info").hide();
	$.ajax({
		url: '/answers_panel/answers',
		data: {
			question_id: "51acb5f9e3bdea3ce0000003"
		},
		success: draw
	});

	$('#similarity_degree').keyup(function(e){
		if(e.keyCode == 13)
		{
			drawEdges($(this).val());
		}
	});

	$("#close_info").click(function(){
		$("#info").fadeOut();
		infoOpen = false;
	});
});