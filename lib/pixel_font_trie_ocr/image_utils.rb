# frozen_string_literal: true

class PixelFontTrieOCR
  module ImageUtils
    attr_accessor :lib

    def temp_dir=(value)
      @temp_dir = Pathname.new(value)
    end

    def temp_dir
      @temp_dir ||= Pathname.new(__dir__).join("..", "..", "tmp")
    end

    def temp_file(name)
      temp_dir.join(name).to_s
    end

    def new_magick_image(width)
      Magick::Image.new(width, height) do |img|
        img.background_color = "white"
      end
    end

    def new_magick_draw
      draw = Magick::Draw.new
      draw.font = font_path
      draw.pointsize = font_size
      draw.fill = "black"
      draw
    end

    def text_image(text, pad: 0)
      case lib
      when :vips
        vips_image(text)
      else
        magick_image(text, pad: pad)
      end
    end

    def magick_image(text, pad: 0)
      draw = new_magick_draw
      metrics = draw.get_type_metrics(text)
      width = metrics.width + pad
      width = 2 if width.zero?
      image = new_magick_image(width.ceil)
      draw.text(0, metrics.ascent.ceil, text).draw(image)
      image
    end

    def escape_vips_text(str)
      str.gsub("&", "&amp;")
         .gsub("<", "&lt;")
         .gsub(">", "&gt;")
         .gsub('"', "&quot;")
         .gsub("'", "&apos;")
    end

    def vips_image(text)
      Vips::Image.text(
        escape_vips_text(text),
        fontfile: font_path,
        font: "#{postscript_name} 8",
        wrap: :none
      ).invert
    rescue Vips::Error => e
      puts "#{e} => text: #{text.inspect}"
      raise e
    end

    def write_text_image(text, name, pad: 0)
      image = text_image(text, pad: pad)
      image.write(temp_file(name))
    end

    def bitmask(image)
      ImageColumnExtractor.new(image).extract
    end

    def vips_mask(mask_columns)
      width = mask_columns.length
      canvas = Vips::Image.black(width, height, bands: 1).invert # white
      canvas.mutate do |mutable|
        mask_columns.each_with_index do |mask, col|
          bitmask_to_array(mask).each_with_index do |bit, row|
            mutable.draw_point!(0, col, height - row - 1) if bit.positive?
          end
        end
      end
    end

    def mask_image(mask_columns)
      draw = new_magick_draw
      image = new_magick_image(mask_columns.length)
      mask_columns.each_with_index do |mask, col|
        bitmask_to_array(mask).each_with_index do |bit, row|
          draw.point(col, height - row - 1) if bit.positive?
        end
      end
      draw.draw(image)
      image
    end
  end
end
