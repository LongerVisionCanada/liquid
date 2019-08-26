# frozen_string_literal: true

module Liquid
  class Ifchanged < Block
    def render_to_output_buffer(context, output)
      context.stack do
        block_output = ''.dup
        super(context, block_output)

        if block_output != context.registers[:ifchanged]
          context.registers[:ifchanged] = block_output
          output << block_output
        end
      end

      output
    end
  end

  Template.register_tag('ifchanged', Ifchanged)
end
