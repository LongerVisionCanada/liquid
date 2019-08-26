# frozen_string_literal: true

class CommentForm < Liquid::Block
  SYNTAX = /(#{Liquid::VARIABLE_SIGNATURE}+)/.freeze

  def initialize(tag_name, markup, options)
    super

    if markup =~ SYNTAX
      @variable_name = Regexp.last_match(1)
      @attributes = {}
    else
      raise SyntaxError, "Syntax Error in 'comment_form' - Valid syntax: comment_form [article]"
    end
  end

  def render_to_output_buffer(context, output)
    article = context[@variable_name]

    context.stack do
      context['form'] = {
        'posted_successfully?' => context.registers[:posted_successfully],
        'errors' => context['comment.errors'],
        'author' => context['comment.author'],
        'email' => context['comment.email'],
        'body' => context['comment.body'],
      }

      output << wrap_in_form(article, render_all(@nodelist, context, output))
      output
    end
  end

  def wrap_in_form(article, input)
    %(<form id="article-#{article.id}-comment-form" class="comment-form" method="post" action="">\n#{input}\n</form>)
  end
end
