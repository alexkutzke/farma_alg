module ApplicationHelper
  def markdown(text)
    options = {:hard_wrap => true, :filter_html => true, :autolink => true,
               :no_intraemphasis => true, :fenced_code => true, :gh_blockcode => true}
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, options)
    markdown.render(text).html_safe
  end

  def similarity_in_words(sim)
        
  end

  def test_case_similarity_in_words(id,tcs)
    t = TestCase.find(id)

    output = ""
    output = output + "<p>"

    if tcs['error'] == 1
      if tcs['both_error'] == 1
        output = output + "As duas respostas <span class=\"label label-important\">falharam</span> no caso de teste <b>" + t.title + "</b>"

        if tcs['same_error'] == 1
          output = output + ", apresentando o mesmo erro."
        elsif tcs['same_error'] == 0
          output = output + ", apresentando erros de tipos diferentes."
        end
      else
        output = output + "Pelo menos uma das respostas <span class=\"label label-important\">falhou</span> no caso de teste <b>" + t.title + "</b>."
      end
    else
      output = output + "As duas respostas foram <span class=\"label label-success\">corretas</span> no caso de teste <b>" + t.title + "</b>"      
    end

    output = output + " Suas saídas para este caso de teste são " + (tcs['output_similarity']*100.0).to_s + "% similares, e o grau de diferença entre a saída esperada é de " + (tcs['diff_to_expected_output']*100.0).to_s + "%."

    output = output + "</p><br/>"
  end
end
