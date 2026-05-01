# frozen_string_literal: true

# lib/pixel_font_trie_ocr/text_image_builder.rb
require "rmagick"

module PixelFontTrieOCR
  class TextImageBuilder
    attr_reader :text, :font_path, :font_size, :height

    def initialize(text, font_path, font_size: 8, height: 8)
      @text = text
      @font_path = font_path
      @font_size = font_size
      @height = height
    end

    def image
      @image ||= begin
        draw.text(2, font_size, text).draw(img)
        img
      end
    end

    def write(path)
      image.write(path)
    end

    def width
      @width ||= (metrics.width + 4).ceil
    end

    private

    def metrics
      @metrics ||= draw.get_type_metrics(text)
    end

    def img
      @img ||= Magick::Image.new(width, height) do |o|
        o.background_color = "white"
      end
    end

    def draw
      @draw ||= begin
        d = Magick::Draw.new
        d.font = font_path
        d.pointsize = font_size
        d.fill = "black"
        d
      end
    end
  end
end
