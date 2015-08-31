module ActionMailer
  module Markdown
    require 'action_mailer'
    require 'action_view'
    require 'redcarpet'

    require 'action_mailer/markdown/version'
    require 'action_mailer/markdown/resolver'
    require 'action_mailer/markdown/ext'
    require 'action_mailer/markdown/renderer'
    require 'action_mailer/markdown/renderer/text'
    require 'action_mailer/markdown/template_handler'
  end
end

ActionMailer::Base.prepend_view_path(ActionMailer::Markdown::Resolver.new)
ActionView::Template.register_template_handler(:md, ActionMailer::Markdown::TemplateHandler::HTML)
ActionView::Template.register_template_handler(:mdt, ActionMailer::Markdown::TemplateHandler::Text)
