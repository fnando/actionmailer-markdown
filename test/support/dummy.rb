# frozen_string_literal: true

class Dummy < Rails::Application
  config.eager_load = false
end

Dummy.initialize!
