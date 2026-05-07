# frozen_string_literal: true

class PixelFontTrieOCR
  module VipsUtils
    def vips_text(text)
      Vips::Image.text(
        escape_vips_text(text),
        fontfile: font_path,
        font: "#{postscript_name} 8",
        wrap: :none
      ).invert
    rescue Vips::Error => e
      raise e.class, "#{e.message} text: #{text.inspect}", e.backtrace
    end

    def vips_mask(mask_columns)
      width = mask_columns.length
      canvas = Vips::Image.black(width, height, bands: 1).invert
      canvas.mutate do |mutable|
        mask_columns.each_with_index do |mask, col|
          bitmask_to_array(mask).each_with_index do |bit, row|
            mutable.draw_point!(0, col, height - row - 1) if bit.positive?
          end
        end
      end
    end

    private

    def escape_vips_text(str)
      str.gsub("&", "&amp;")
         .gsub("<", "&lt;")
         .gsub(">", "&gt;")
         .gsub('"', "&quot;")
         .gsub("'", "&apos;")
    end
  end
end
