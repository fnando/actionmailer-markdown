class Mailer < ActionMailer::Base
  prepend_view_path "#{__dir__}"

  def hello(name)
    @name = name
    mail to: 'noreply@example.com'
  end

  def welcome
    mail to: 'noreply@example.com'
  end

  def ohai
    mail to: 'ohai' do |format|
      format.text
    end
  end

  def kthxbai
    mail to: 'noreply@example.com', subject: 'kthxbai'
  end

  def activation
    @activation_url = 'http://example.com/activate/4d4b4396-dc26-47c4-b433-2cd9a1b45ce1'
    mail to: 'noreply@example.com'
  end
end
