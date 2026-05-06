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

    def new_image(width)
      Magick::Image.new(width, height) do |img|
        img.background_color = "white"
      end
    end

    def new_draw
      draw = Magick::Draw.new
      draw.font = font_path
      draw.pointsize = font_size
      draw.fill = "black"
      draw
    end

    def text_image(text, pad: 0)
      draw = new_draw
      metrics = draw.get_type_metrics(text)
      width = metrics.width + pad
      width = 2 if width.zero?
      puts "drawing #{text.inspect} width: #{width}" if width < 1
      image = new_image(width.ceil)
      draw.text(0, metrics.ascent.ceil, text).draw(image)
      image
    end

    def write_text_image(text, name, pad: 0)
      image = text_image(text, pad: pad)
      image.write(temp_file(name))
    end

    def bitmask(image)
      ImageColumnExtractor.new(image).extract
    end

    def mask_image(mask_columns)
      draw = new_draw
      image = new_image(mask_columns.length)
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
