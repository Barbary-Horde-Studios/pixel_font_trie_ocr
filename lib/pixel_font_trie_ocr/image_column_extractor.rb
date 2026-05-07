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

    def width
      @width ||= image_width
    end

    def height
      @height ||= image_height
    end

    def get_column(col)
      pixels = extract_column_pixels(col).reverse
      pixels.map.with_index do |p, row|
        black?(p) ? (1 << row) : 0
      end.sum
    end

    def pixel_values(pixel)
      case pixel
      when Magick::Pixel
        [pixel.red, pixel.green, pixel.blue]
      when Array
        pixel.take(3)
      else
        []
      end
    end

    def intensity(pixel)
      values = pixel_values(pixel)
      size = values.size
      return 0 if size.zero?

      values.sum.to_f / size * value_scale
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

    def image_width
      vips_image? ?  image.width : image.columns
    end

    def image_height
      vips_image? ?  image.height : image.rows
    end

    def extract_column_pixels(col)
      if vips_image?
        # Vips::Image#getpoint(x, y) returns [r, g, b, ...]
        (0...height).map { |row| image.getpoint(col, row) }
      else
        # Original RMagick path
        image.get_pixels(col, 0, 1, height)
      end
    end

    def vips_image?
      @vips_image ||= defined?(Vips) && image.is_a?(Vips::Image)
    end

    def value_scale
      @value_scale ||= 255.0 / max_value
    end

    def max_value
      return 255.0 unless vips_image?

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
