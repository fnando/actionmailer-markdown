module ActionMailer
  module Markdown
    require 'action_mailer'
    require 'redcarpet'

    require 'action_mailer/markdown/version'
    require 'action_mailer/markdown/ext'
    require 'action_mailer/markdown/renderer'
    require 'action_mailer/markdown/renderer/text'
  end
end
