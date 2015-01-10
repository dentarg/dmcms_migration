require "bb-ruby"
require "sanitize"

class Clean
  def self.text(text)
    text = text.bbcode_to_html({}, false)

    options = {
      elements: [
        "a",
        "br"
      ],
      attributes: {
        "a" => ["href"],
      }
    }
    Sanitize.fragment(text, options)
  end
end
