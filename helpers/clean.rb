require "bb-ruby"
require "sanitize"

require_relative "youtube_transformer"

class Clean
  def self.text(text)
    text = text.bbcode_to_html({}, false)

    options = {
      elements: %w[a br ul li iframe],
      attributes: {
        "a" => ["href"],
      },
      whitespace_elements: {
        'br'  => { :before => "\n", :after => "" },
        'div' => { :before => "\n", :after => "\n" },
        'p'   => { :before => "\n", :after => "\n" }
      },
      transformers: youtube_transformer,
    }
    Sanitize.fragment(text, options)
  end
end
