# frozen_string_literal: true

class PixelFontTrieOCR
  module MagickUtils
    def magick_text(text, pad: 0)
      draw = new_magick_draw
      metrics = draw.get_type_metrics(text)
      width = metrics.width + pad
      width = 2 if width.zero?
      image = new_magick_image(width.ceil)
      draw.text(0, metrics.ascent.ceil, text).draw(image)
      image
    end

    def magick_mask(mask_columns)
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

    private

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
  end
end
