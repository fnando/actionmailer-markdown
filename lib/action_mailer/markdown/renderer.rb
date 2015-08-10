module ActionMailer
  module Markdown
    class Renderer < Redcarpet::Render::HTML
      include Redcarpet::Render::SmartyPants
    end

    class << self
      # Set markdown renderer
      attr_accessor :processor, :default_processor
    end

    renderer = Renderer.new(hard_wrap: true, safe_links_only: true)

    markdown_engine = Redcarpet::Markdown.new(renderer, {
      tables: true,
      footnotes: true,
      space_after_headers: true,
      superscript: true,
      highlight: true,
      strikethrough: true,
      autolink: true,
      no_intra_emphasis: true
    })

    self.default_processor = -> text { markdown_engine.render(text) }
    self.processor = default_processor

    def self.html(text)
      processor.call(text)
    end

    def self.text(source)
      Renderer::Text.extract(source)
    end
  end
end
