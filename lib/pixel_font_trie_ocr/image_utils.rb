# frozen_string_literal: true

class PixelFontTrieOCR
  module ImageUtils
    def temp_dir=(value)
      @temp_dir = Pathname.new(value)
    end

    def temp_dir
      @temp_dir ||= Pathname.new(__dir__).join("..", "..", "tmp")
    end

    def temp_file(name)
      temp_dir.join(name).to_s
    end

    def mask_image(mask_columns)
      case lib
      when :vips
        vips_mask(mask_columns)
      else
        magick_mask(mask_columns)
      end
    end

    def text_image(text, pad: 0)
      case lib
      when :vips
        vips_text(text)
      else
        magick_text(text, pad: pad)
      end
    end

    def write_text_image(text, name, pad: 0)
      image = text_image(text, pad: pad)
      if image.respond_to? :write
        image.write(temp_file(name))
      elsif image.respond_to? :write_to_file
        image.write_to_file(temp_file(name))
      end
    end
  end
end
