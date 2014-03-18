class Carrie.Models.TestCase extends Backbone.RelationalModel
  urlRoot: ->
    exer = @get('question').get('exercise')
    '/api/los/' + exer.get('lo').get('id') + '/exercises/' + exer.get('id') + '/questions/' + @get('question').get('id') + '/test_cases'

  paramRoot: 'test_case'

  defaults:
    'content': ''
    'tip': ''
    'input': ''
    'output': ''
    'timeout': '1'

  toJSON: ->
    id: @get('id')
    title: @get('title')
    content: @get('content')
    tip: @get('tip')
    input: @get('input')
    output: @get('output')
    timeout: @get('timeout')
    ignore_presentation: @get('ignore_presentation')
    show_input_output: @get('show_input_output')
    lo_id: @get('question').get('exercise').get('lo').get('id')
    exercise_id: @get('question').get('exercise').get('id')
    question_id: @get('question').get('id')

Carrie.Models.TestCase.setup()
