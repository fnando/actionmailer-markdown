require 'test_helper'

class MarkdownTest < Minitest::Test
  teardown do
    ActionMailer::Markdown.processor = ActionMailer::Markdown.default_processor
  end

  test 'render html part' do
    mail = Mailer.hello('John')
    html = mail.html_part.body.raw_source

    assert_equal 'Hello there, John', mail.subject
    assert_includes html, '<p>Hello there, John!</p>'
    assert_includes html, '<p>This is just a <em>welcome</em> e-mail.</p>'
    assert_includes html, %[<p>&ndash;<br>\nFor more info, go to <a href="http://example.com">http://example.com</a></p>]
  end

  test 'render text part' do
    mail = Mailer.hello('Mary')
    text = mail.text_part.body.raw_source

    assert_equal 'Hello there, Mary', mail.subject
    assert_match %r[^Hello there, Mary!$], text
    assert_match %r[^This is just a welcome e-mail\.$], text
    assert_match %r[^For more info, go to http://example\.com$], text
  end

  test 'render layout (text)' do
    mail = Mailer.hello('Mary')
    text = mail.text_part.body.raw_source

    assert_includes text, "\nThanks,\nACME Team"
  end

  test 'render layout (html)' do
    mail = Mailer.hello('Mary')
    html = mail.html_part.body.raw_source

    assert_includes html, '<p>Thanks,<br>ACME Team</p>'
  end

  test 'uses template' do
    mail = Mailer.welcome
    assert_match /^Welcome!$/, mail.body.raw_source
  end

  test 'uses provided block' do
    mail = Mailer.ohai
    assert_match /^OHAI!$/, mail.body.raw_source
  end

  test 'uses specified subject' do
    mail = Mailer.kthxbai
    assert 'kthxbai', mail.subject
  end

  test 'renders parts without i18n subject' do
    mail = Mailer.kthxbai
    text = mail.text_part.body.raw_source
    html = mail.html_part.body.raw_source

    assert mail.multipart?
    assert_match /^#kthxbai$/, text
    assert_match /^\s*<p>#kthxbai<\/p>$/, html
  end

  test 'renders urls' do
    mail = Mailer.activation
    html = mail.html_part.body.raw_source
    text = mail.text_part.body.raw_source

    assert_includes html, '<a href="http://example.com/activate/4d4b4396-dc26-47c4-b433-2cd9a1b45ce1">do activate your account</a>'
    assert_includes text, 'do activate your account[1]'
    assert_includes text, '[1]: http://example.com/activate/4d4b4396-dc26-47c4-b433-2cd9a1b45ce1'
  end

  test 'custom markdown processor' do
    ActionMailer::Markdown.processor = -> text { Kramdown::Document.new(text).to_html }
    mail = Mailer.kthxbai
    html = mail.html_part.body.raw_source

    assert mail.multipart?
    assert_includes html, %[<h1 id="kthxbai">kthxbai</h1>]
  end
end
