require "./lib/action_mailer/markdown/version"

Gem::Specification.new do |spec|
  spec.name          = "actionmailer-markdown"
  spec.version       = ActionMailer::Markdown::VERSION
  spec.authors       = ["Nando Vieira"]
  spec.email         = ["fnando.vieira@gmail.com"]
  spec.summary       = "A different take on using ActionMailer, Markdown and I18n."
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/fnando/actionmailer-markdown"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject {|f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) {|f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "actionmailer"
  spec.add_dependency "redcarpet"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rails"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-utils"
  spec.add_development_dependency "pry-meta"
  spec.add_development_dependency "kramdown"
end
