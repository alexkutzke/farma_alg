module ApplicationHelper
  def markdown(text)
    options = {:hard_wrap => true, :filter_html => true, :autolink => true,
               :no_intraemphasis => true, :fenced_code => true, :gh_blockcode => true}
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, options)
    markdown.render(text).html_safe
  end

  def similarity_in_words(sim)

  end

  def render_progress(x,msg,css=nil)
    if css.nil?
      css = "width:70px;"
    end

    p = 100 * x
    if p == 100
      style = "success"
    elsif p > 49
      style = "yellow"
    else
      style = "danger"
    end

    raw "<div class=\"progress xs\" style=\"#{css}\"><div rel=\"tooltip\" data-toggle=\"tooltip\" data-placement=\"top\" title data-original-title=\"#{p.round(0).to_s}#{msg}\" class=\"progress-bar progress-bar-#{style}\" style=\"width: #{p}%\"></div></div>"
  end

  def paginate(as)
    render(:partial => 'dashboard/paginator', :locals => {:as => as})
  end

  def answer_link(answer,c=nil)
    render(:partial => 'dashboard/answers/answer_link', :locals => {:answer => answer, :c => c})
  end

  def answer_labels(answer)
    render(:partial => 'dashboard/answers/answer_labels', :locals => {:answer => answer})
  end

  def recent_activity(data)
    render(:partial => 'dashboard/recent_activity', :locals => {:data => data})
  end

  def pie_chart(data, title)
    render(:partial => 'dashboard/pie_chart', :locals => {:data => data, :title => title})
  end

  def filter_in_words(params)
    render(:partial => 'dashboard/filter_in_words', :locals => {:params => params})
  end

  def test_case_title(id)
    t = TestCase.find_or_initialize_by({:id => id})
    if not t.new_record?
      t.title
    else
      nil
    end
  end

  def test_case_input(id)
    t = TestCase.find_or_initialize_by({:id => id})
    if not t.new_record?
      t.input
    else
      nil
    end
  end

  def test_case_similarity_in_words(id,tcs)
    t = TestCase.find_or_initialize_by({:id => id})

    output = ""

    unless t.new_record?
      output = ""
      output = output + "<p>"

      if tcs['error'] == 1
        if tcs['both_error'] == 1
          output = output + "As duas respostas <span class=\"label label-danger\">falharam</span> no caso de teste <b>" + t.title + "</b>"

          if tcs['same_error'] == 1
            output = output + ", apresentando o mesmo erro."
          elsif tcs['same_error'] == 0
            output = output + ", apresentando erros de tipos diferentes."
          end
        else
          output = output + "Pelo menos uma das respostas <span class=\"label label-danger\">falhou</span> no caso de teste <b>" + t.title + "</b>."
        end
      else
        output = output + "As duas respostas foram <span class=\"label label-success\">corretas</span> no caso de teste <b>" + t.title + "</b>"
      end

      output = output + " Suas saídas para este caso de teste são " + (tcs['output_similarity']*100.0).to_s + "% similares, e o grau de diferença entre a saída esperada é de " + (tcs['diff_to_expected_output']*100.0).to_s + "%."

      output = output + "</p><br/>"
    end

    output
  end

  def render_tag(t,big)
    if t.type == 1
     label = "label-danger"
    elsif t.type == 2
      label = "label-warning"
    else
      label = "label-success"
    end

    raw "<span data-id=\"#{t.id}\" style=\"margin: 3px 3px;\" rel=\"tooltip\" data-toggle=\"tooltip\" data-placement=\"top\" title data-original-title=\"#{t.description}\" class=\"#{"tags" if big} label #{label}\">#{t.name}</span>"
  end

  def build_message_link(recommendation)
    final = "?"

    unless recommendation.item['user_ids'].nil?
      recommendation.item['user_ids'].each do |user_id|
        final = final + "message[user_ids][]=" + user_id.to_s + "&"
      end
    end

    unless recommendation.item['answer_ids'].nil?
      recommendation.item['answer_ids'].each do |answer_id|
        final = final + "message[answer_ids][]=" + answer_id.to_s + "&"
      end
    end

    unless recommendation.item['message_team_id'].nil?
      final = final + "message[team_ids][]=" + recommendation.item['message_team_id'].to_s + "&"
    end

    unless recommendation.item['question_id'].nil?
      final = final + "message[question_ids][]=" + recommendation.item['question_id'].to_s + "&"
    end

    final
  end

end
