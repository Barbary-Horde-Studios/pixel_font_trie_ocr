# frozen_string_literal: true

# FontImageGenerator generates a series of images based on the glyphs
# defined in a font. Uses FontInspector to discover characters,
# renders each with TextImageBuilder, and extracts bitmask arrays
# using ImageColumnExtractor.

module PixelFontTrieOCR
  class FontImageGenerator
    attr_reader :font_path, :font_size, :height

    def initialize(font_path, font_size: 8, height: 8)
      @font_path = font_path
      @font_size = font_size
      @height = height
    end

    def inspector
      @inspector ||= FontInspector.new(font_path)
    end

    def characters
      @characters ||= inspector.character_list
    end

    def pixel_height
      @pixel_height ||= ((inspector.ascent / inspector.units_per_em.to_f) * font_size).ceil + 2
    end

    def draw
      @draw ||=
        begin
          draw = Magick::Draw.new
          draw.font = font_path
          draw.pointsize = font_size
          draw.fill = "black"
          draw
        end
    end

    def image(message)
      metrics = draw.get_type_metrics(message)
      width = (metrics.width + 4).ceil
      img = Magick::Image.new(width, pixel_height) { |c| c.background_color = "white" }
      # Position: 1px top whitespace + ascent (distance from baseline to top)
      y_position = 1 + metrics.ascent.ceil
      draw.text(2, y_position, message)
      draw.draw(img)
      img
    end

    def bitmask(image)
      ImageColumnExtractor.new(image, height_limit: height).extract
    end

    def generate
      @generate ||= characters.map do |char|
        img = image(char)
        {
          char: char,
          image: img,
          bitmask: bitmask(img)
        }
      end
    end
  end
end
