ActionMailer::Base.class_eval do
  mail_method = instance_method(:mail)

  define_method(:mail) do |headers = {}, &block|
    options = variables_set_by_user
    message = get_translation_for('body', options)
    subject = get_translation_for('subject', options)
    headers[:subject] ||= subject

    if message
      block = proc do |format|
        format.text { render plain: ActionMailer::Markdown.text(message) }
        format.html { render html: ActionMailer::Markdown.html(message).html_safe }
      end
    end

    mail_method.bind(self).call(headers, &block)
  end

  def mailer_scope
    self.class.mailer_name.tr('/', '.')
  end

  def get_translation_for(key, options)
    I18n.t(key, options.merge(scope: [mailer_scope, action_name], raise: true))
  rescue I18n::MissingTranslationData
    nil
  end

  def variables_set_by_user
    instance_variables.each_with_object({}) do |name, buffer|
      next if name.match(/^@_/)
      name = name.to_s[/^@(.*?)$/, 1]
      buffer[name.to_sym] = instance_variable_get("@#{name}")
    end
  end
end
