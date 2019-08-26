# frozen_string_literal: true

module Liquid
  class Raw < Block
    SYNTAX = /\A\s*\z/.freeze
    FULL_TOKEN_POSSIBLY_INVALID = /\A(.*)#{TAG_START}\s*(\w+)\s*(.*)?#{TAG_END}\z/om.freeze

    def initialize(tag_name, markup, parse_context)
      super

      ensure_valid_markup(tag_name, markup, parse_context)
    end

    def parse(tokens)
      @body = ''.dup
      while (token = tokens.shift)
        if token =~ FULL_TOKEN_POSSIBLY_INVALID
          @body << Regexp.last_match(1) if Regexp.last_match(1) != ''
          return if block_delimiter == Regexp.last_match(2)
        end
        @body << token unless token.empty?
      end

      raise SyntaxError, parse_context.locale.t('errors.syntax.tag_never_closed', block_name: block_name)
    end

    def render_to_output_buffer(_context, output)
      output << @body
      output
    end

    def nodelist
      [@body]
    end

    def blank?
      @body.empty?
    end

    protected

    def ensure_valid_markup(tag_name, markup, parse_context)
      raise SyntaxError, parse_context.locale.t('errors.syntax.tag_unexpected_args', tag: tag_name) unless markup =~ SYNTAX
    end
  end

  Template.register_tag('raw', Raw)
end
