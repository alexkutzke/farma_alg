var html = "";

html += "<div id='<%= @comment.id %>' class='comment hide'><div class='avatar'><img class='gravatar' src='http://www.gravatar.com/avatar/<%= @comment.user.gravatar%>?s=48'/></div>";

html += "<div class='main clearfix'><div class='headline'>Criado por <%= @comment.user.name %> à <strong> <%= time_ago_in_words(@comment.created_at) unless @comment.created_at.blank? %> atrás</strong>";

<% if @comment.can_destroy?(current_user) %>
html += "<div class='right'>";
html += "<a href='/api/answers/<%= @answer.id %>/comments/<%= @comment.id %>' data-confirm='Você tem certeza?' data-method='delete' data-remote='true' rel='nofollow'>";
html += "<i class='icon-remove'></i> Remover comentário</a>";
html += "</div>";
<% end %>


html += "</div><div class='comment_content'><p> <%= simple_format @comment.text %></p></div></div>";

$(".comments-list").append(html);

$("#<%= @comment.id %>").fadeIn(1000);