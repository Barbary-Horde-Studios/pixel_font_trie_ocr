# frozen_string_literal: true

class PixelFontTrieOCR
  class MagickColumnExtractor < ImageColumnExtractor
    private

    def width
      @width ||= image.columns
    end

    def height
      @height ||= image.rows
    end

    def intensity(pixel)
      [pixel.red, pixel.green, pixel.blue].sum.to_f / 3
    end

    def extract_column_pixels(col)
      image.get_pixels(col, 0, 1, height)
    end
  end
end
