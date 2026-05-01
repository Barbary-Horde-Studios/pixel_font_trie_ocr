# frozen_string_literal: true

# lib/pixel_font_trie_ocr/image_column_extractor.rb
require "rmagick"

module PixelFontTrieOCR
  class ImageColumnExtractor
    attr_reader :image_path, :height_limit, :threshold

    def initialize(source, height_limit: 8, threshold: 38_000)
      if source.is_a?(Magick::Image)
        @img = source
        @image_path = nil
      else
        @image_path = source
        @img = nil
      end
      @height_limit = height_limit
      @threshold = threshold
    end

    def extract
      build_column_masks
    end

    def img
      @img ||= image_path ? Magick::Image.read(image_path).first : nil
      @img
    end

    def width
      @width ||= img.columns
    end

    def height
      @height ||= img.rows
    end

    def get_column(col)
      pixels = img.get_pixels(col, 0, 1, height)
      pixels.map.with_index do |p, row|
        black?(p) ? (1 << row) : 0
      end.sum
    end

    private

    def black?(pixel)
      (pixel.red + pixel.green + pixel.blue) < threshold
    end

    def build_column_masks
      validate_height!
      (0...width).map { |col| get_column(col) }
    end

    def validate_height!
      raise "Image height (#{height}) exceeds limit (#{height_limit})" if height > height_limit
    end
  end
end
