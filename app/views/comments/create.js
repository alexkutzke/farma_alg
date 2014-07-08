var html = "";


html += "<div id='<%=@comment.id%>' class='box box-solid' style='border: 1px solid lightgray;'>";
html += "<div class='box-header'>";
html += "<h3 class='box-title' style='width:100%;'>";
html += "<div class='pull-left image'>";
html += "<img src='http://www.gravatar.com/avatar/<%= @comment.user.gravatar%>' class='img-circle' alt='Imagem do usuário' style='width:50px;margin-right:10px;'/>";
html += "</div>";
html += "<%= @comment.user.name %>";
<% if @comment.can_destroy?(current_user) %>
html += "<div class='box-tools pull-right' style='padding-right:10px;'>";
html += "<a href='/api/answers/<%= @comment.answer_id %>/comments/<%= @comment.id %>' data-confirm='Você tem certeza?' data-method='delete' data-remote='true' rel='nofollow'>";
html += "<button class='btn btn-sm btn-danger' name='button' type='submit'>Apagar</button></a>";
html += "</div>"
<% end %>
html += "<br><small><i class='fa fa-clock-o'></i> há <%= time_ago_in_words @comment.created_at %></small></h3></div><div class='box-body'><%= simple_format @comment.text %></div></div>";

$(".comments-list").append(html);

$("#<%= @comment.id %>").fadeIn(1000);