class MessageMailer < ActionMailer::Base
  default :from => "nao-responda-farma-alg@c3sl.ufpr.br"

  def message_received(message, user)
    @message = message
    @user = user
    mail(:to => user.email, :subject => "[Farma-Alg] Você recebeu uma mensagem. (#{Time.now})")
  end

  def reply_received(reply,message, user)
    @reply = reply
    @message = message
    @user = user
    mail(:to => user.email, :subject => "[Farma-Alg] Novo comentário em mensagem. (#{Time.now})")
  end

  def comment_received(comment,user)
    @comment = comment
    @answer = comment.answer
    @question = @answer.question
    @user = user
    mail(:to => user.email, :subject => "[Farma-Alg] Novo comentário em resposta. (#{Time.now})")
  end
end
