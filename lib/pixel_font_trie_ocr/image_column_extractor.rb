# frozen_string_literal: true

class PixelFontTrieOCR
  class ImageColumnExtractor
    attr_reader :image, :threshold

    def initialize(image, threshold: 120)
      @image = image
      @threshold = threshold
    end

    def extract
      trim_masks(masks)
    end

    private

    def get_column(col)
      pixels = extract_column_pixels(col).reverse
      pixels.map.with_index do |p, row|
        black?(p) ? (1 << row) : 0
      end.sum
    end

    def black?(pixel)
      intensity(pixel) < threshold
    end

    def masks
      (0...width).map { |col| get_column(col) }
    end

    def trim_masks(masks)
      first_non_zero = masks.find_index(&:positive?)
      return [0, 0] unless first_non_zero

      last_non_zero = masks.rindex(&:positive?)
      masks[first_non_zero..last_non_zero] + [0]
    end

    def extract_column_pixels(col)
      image.get_pixels(col, 0, 1, height)
    end
  end
end
