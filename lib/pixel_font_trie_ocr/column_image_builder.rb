# frozen_string_literal: true

# lib/pixel_font_trie_ocr/column_image_builder.rb
require "rmagick"

module PixelFontTrieOCR
  class ColumnImageBuilder
    attr_reader :columns, :height

    def initialize(columns, height: 8)
      @columns = columns
      @height = height
    end

    def write(path)
      image.write(path)
    end

    def width
      @width ||= columns.size
    end

    def image
      @image ||= draw_columns_on(new_image)
    end

    private

    def new_image
      Magick::Image.new(width, height) do |o|
        o.background_color = "white"
      end
    end

    def draw
      @draw ||= begin
        d = Magick::Draw.new
        d.fill = "black"
        d
      end
    end

    def draw_columns_on(img)
      drawn = false
      columns.each_with_index do |mask, col|
        (0...height).each do |row|
          if (mask & (1 << row)) != 0
            draw.point(col, row)
            drawn = true
          end
        end
      end
      draw.draw(img) if drawn
      img
    end
  end
end
