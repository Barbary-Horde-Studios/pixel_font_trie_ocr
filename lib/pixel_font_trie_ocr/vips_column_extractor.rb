# frozen_string_literal: true

class PixelFontTrieOCR
  class VipsColumnExtractor < ImageColumnExtractor
    private

    def width
      @width ||= image.width
    end

    def height
      @height ||= image.height
    end

    def intensity(pixel)
      values = pixel.take(3)
      size = values.size
      return 0 if size.zero?

      values.sum.to_f / size * value_scale
    end

    def extract_column_pixels(col)
      (0...height).map { |row| image.getpoint(col, row) }
    end

    def value_scale
      @value_scale ||= 255.0 / max_value
    end

    def max_value
      case image.format
      when :uchar   then 255.0
      when :ushort  then 65_535.0
      when :uint    then 4_294_967_295.0 # very rare
      when :float   then 1.0 # normalized float
      when :double  then 1.0
      else 255.0 # fallback
      end
    end
  end
end
