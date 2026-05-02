# frozen_string_literal: true

class PixelFontTrieOCR
  class ImageColumnExtractor
    attr_reader :image, :threshold

    def initialize(image, threshold: 38_000)
      @image = image
      @threshold = threshold
    end

    def extract
      trim_masks(masks)
    end

    private

    def width
      @width ||= image.columns
    end

    def height
      @height ||= image.rows
    end

    def get_column(col)
      pixels = image.get_pixels(col, 0, 1, height).reverse
      pixels.map.with_index do |p, row|
        black?(p) ? (1 << row) : 0
      end.sum
    end

    def black?(pixel)
      (pixel.red + pixel.green + pixel.blue) < threshold
    end

    def masks
      (0...width).map { |col| get_column(col) }
    end

    def trim_masks(masks)
      first_non_zero = masks.find_index(&:positive?)
      return [0,0] unless first_non_zero

      last_non_zero = masks.rindex(&:positive?)
      masks[first_non_zero..last_non_zero] + [0]
    end
  end
end
