# frozen_string_literal: true

ActionMailer::Base.class_eval do
  mail_method = instance_method(:mail)

  define_method(:mail) do |headers = {}, &block|
    options = variables_set_by_user
    subject = get_translation_for("subject", options)
    headers[:subject] ||= subject
    headers[:locals] = {a: 1}
    mail_method.bind_call(self, headers, &block)
  end

  def get_translation_for(key, options)
    I18n.t(key, **options.merge(scope: [mailer_scope, action_name], raise: true))
  rescue I18n::MissingTranslationData
    nil
  end

  def variables_set_by_user
    instance_variables.each_with_object({}) do |name, buffer|
      next if /^@_/.match?(name)

      name = name.to_s[/^@(.*?)$/, 1]
      buffer[name.to_sym] = instance_variable_get("@#{name}")
    end
  end

  def mailer_scope
    self.class.mailer_name.tr("/", ".")
  end
end
