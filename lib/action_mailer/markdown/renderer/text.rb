module ActionMailer
  module Markdown
    class Renderer
      class Text
        attr_reader :source, :root

        def self.extract(source)
          new(source).extract
        end

        def initialize(source)
          @source = source
          @root = Nokogiri::HTML(Markdown.html(source)).css("body")
        end

        def extract
          process_hr
          process_links
          process_h1
          process_h2
          process_lists
          process_code

          root.text
        end

        def process_code
          root.css("code").each do |code|
            next if code.parent.name == "pre"
            code.content = "`#{code.content}`"
          end
        end

        def process_hr
          root.css("hr").each(&:remove)
        end

        def process_h1
          root.css("h1").each do |heading|
            heading.content = build_heading(heading.text, "=")
          end
        end

        def process_h2
          root.css("h2").each do |heading|
            heading.content = "\n#{build_heading(heading.text, "-")}"
          end
        end

        def process_lists
          root.css("ol, ul").each do |list|
            list.css("li").to_enum(:each).with_index(1) do |item, index|
              prefix = (list.name == "ol" ? "#{index}." : "-")
              item.content = "#{prefix} #{item.text}"
            end
          end
        end

        def process_links
          links = []

          root.css("a").each do |link|
            href = link["href"]

            if href.starts_with?("mailto:")
              link.content = href.sub("mailto:", "")
            elsif link.content.match(%r[^(?!\w+://)])
              links << href unless links.include?(href)
              index = links.index(href) + 1
              link.content = "#{link.content}[#{index}]"
            end
          end

          links_list = links.map.with_index(1) {|link, index| "[#{index}]: #{link}" }.join("\n")
          node = Nokogiri::HTML.fragment "<pre>\n#{links_list}\n</pre>"

          root << node
        end

        private

        def build_heading(text, separator)
          "#{text}\n#{separator * text.size}"
        end
      end
    end
  end
end
