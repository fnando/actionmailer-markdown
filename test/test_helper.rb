# frozen_string_literal: true

require "simplecov"
require "simplecov-console"

SimpleCov.minimum_coverage 100
SimpleCov.minimum_coverage_by_file 100
SimpleCov.refuse_coverage_drop

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::Console,
  SimpleCov::Formatter::HTMLFormatter
])

SimpleCov.start do
  add_filter "test/support"
end

require "bundler/setup"
require "rails"
require "action_mailer/railtie"
require "actionmailer-markdown"
require "minitest/autorun"
require "minitest/utils"
require "kramdown"

require_relative "./support/dummy"
require_relative "./support/mailer"
I18n.load_path += Dir["#{__dir__}/support/locales/**/*.yml"]
