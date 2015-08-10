$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'actionmailer-markdown'
require 'minitest/autorun'
require 'minitest/utils'
require 'kramdown'

require_relative './support/mailer'
I18n.load_path += Dir["#{__dir__}/support/locales/**/*.yml"]
