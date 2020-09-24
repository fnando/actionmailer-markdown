# frozen_string_literal: true

require "test_helper"

class TextTest < Minitest::Test
  test "render links" do
    source = File.read("./test/support/texts/links.md")
    text = ActionMailer::Markdown::Renderer::Text.extract(source)

    assert text.include?("Markdown[1] => http://daringfireball.net/projects/markdown/")
    assert text.include?("Markdown[1] is nice!")
    assert text.include?("[1]: http://daringfireball.net/projects/markdown/")

    assert text.include?("CommonMark[2] => http://commonmark.org/")
    assert text.include?("[2]: http://commonmark.org/")

    assert text.include?("Send feedback to john@example.com")

    assert text.include?("redcarpet[3] => https://github.com/vmg/redcarpet")
    assert text.include?("[3]: https://github.com/vmg/redcarpet")
  end

  test "render ordered lists" do
    source = File.read("./test/support/texts/lists.md")
    text = ActionMailer::Markdown::Renderer::Text.extract(source)

    assert text.include?("1. Item 1")
    assert text.include?("2. Item 2")
    assert text.include?("3. Item 3")
  end

  test "render unordered lists" do
    source = File.read("./test/support/texts/lists.md")
    text = ActionMailer::Markdown::Renderer::Text.extract(source)

    assert text.include?("- Item A")
    assert text.include?("- Item B")
    assert text.include?("- Item C")
  end

  test "render main heading" do
    source = File.read("./test/support/texts/links.md")
    text = ActionMailer::Markdown::Renderer::Text.extract(source)

    assert text.include?("About Markdown\n==============\n\n")
  end

  test "render secondary heading" do
    source = File.read("./test/support/texts/links.md")
    text = ActionMailer::Markdown::Renderer::Text.extract(source)

    assert text.include?("Feedback\n--------\n\n")
  end

  test "render code" do
    source = File.read("./test/support/texts/code.md")
    text = ActionMailer::Markdown::Renderer::Text.extract(source)

    assert text.include?("Look at `ActionMailer::Base` class for this.")
    assert_match(/^This is just a code block\.$/, text)
  end
end
