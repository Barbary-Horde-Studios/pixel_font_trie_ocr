# frozen_string_literal: true

class PixelFontTrieOCR
  class ImageColumnExtractor
    attr_reader :image, :threshold, :min_x, :max_x, :min_y, :max_y

    def initialize(image, threshold: 38_000)
      @image = image
      @threshold = threshold
      @min_x = image.columns
      @max_x = 0
      @min_y = image.rows
      @max_y = 0
    end

    def black(x, y)
      @min_x = [min_x, x].min
      @max_x = [max_x, x].max
      @min_y = [min_y, y].min
      @max_y = [max_y, y].max
    end

    def extract
      auto_select
      return [0, 0] unless black_pixels?

      crop
      trim_masks(masks)
    end

    private

    def auto_select
      image.each_pixel do |pixel, x, y|
        black(x, y) if black?(pixel)
      end
    end

    def black_pixels?
      min_x > max_x # no black pixels
    end

    def crop
      @width = max_x - min_x + 1
      @height = max_y - min_y + 1
      @image = image.crop(min_x, min_y, width, height, true)
    end

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
      return [0, 0] unless first_non_zero

      last_non_zero = masks.rindex(&:positive?)
      masks[first_non_zero..last_non_zero] + [0]
    end
  end
end
