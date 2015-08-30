module ActionMailer
  module Markdown
    module TemplateHandler
      UNDERSCORE = '_'.freeze

      def self.render(template, context, format)
        source = template.rstrip % extract_variables(context)
        ActionMailer::Markdown.public_send(format, source)
      end

      def self.extract_variables(context)
        context
          .instance_variable_get(:@_assigns)
          .each_with_object({}) do |(name, value), buffer|
            next if name.start_with?(UNDERSCORE)
            buffer[name.to_sym] = value
          end
      end

      class Text
        def self.call(template)
          %[ActionMailer::Markdown::TemplateHandler.render(#{template.source.inspect}, self, :text)]
        end
      end

      class HTML
        def self.call(template)
          %[ActionMailer::Markdown::TemplateHandler.render(#{template.source.inspect}, self, :html)]
        end
      end
    end
  end
end
