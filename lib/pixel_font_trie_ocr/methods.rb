# frozen_string_literal: true

require "rmagick"
require "ttfunk"
require_relative "image_column_extractor"
require_relative "trie"

class PixelFontTrieOCR
  module Methods
    DEFAULT_FONT_NAME = "hex-synergy_font.ttf"

    attr_writer :font_name, :font_size

    def array_to_bitmask(array)
      array.inject(0) { |acc, bit| (acc << 1) | bit }
    end

    def bitmask_to_array(bitmask, length: nil)
      Array.new(length || bitmask.bit_length) { |i| (bitmask >> i) & 1 }
    end

    def font_name
      @font_name ||= DEFAULT_FONT_NAME
    end

    def font_dir=(value)
      @font_dir = Pathname.new(value)
    end

    def font_dir
      @font_dir ||= Pathname.new(__dir__).join("fonts")
    end

    def temp_dir=(value)
      @temp_dir = Pathname.new(value)
    end

    def temp_dir
      @temp_dir ||= Pathname.new(__dir__).join('..','..','tmp')
    end

    def temp_file(name)
      temp_dir.join(name).to_s
    end

    def font_path
      @font_path ||= font_dir.join(font_name).to_s
    end

    def font_size
      @font_size ||= 8
    end

    def font
      @font ||= TTFunk::File.open(font_path)
    end

    def font_map
      @font_map ||= font.cmap.unicode.first
    end

    def code_map
      @code_map ||= font_map.respond_to?(:code_map) ? font_map.code_map : {}
    end

    # Returns a list of all characters supported by the font
    def characters
      @characters ||= Set.new(
        code_map.filter_map do |key, value|
          value.positive? && key > 31 && [key].pack("U")
        end
      )
    end

    def family
      @family ||= font.name.font_name
    end

    def subfamily
      @subfamily ||= font.name.font_subfamily
    end

    def postscript_name
      @postscript_name ||= font.name.postscript_name
    end

    def character_count
      @character_count ||= characters.size
    end

    def ascent
      @ascent ||= font.os2.ascent
    end

    def descent
      @descent ||= font.os2.descent
    end

    def units_per_em
      @units_per_em ||= font.header.units_per_em
    end

    def ascent_ratio
      @ascent_ratio ||= ascent / units_per_em.to_f
    end

    def height
      @height ||= (ascent_ratio * font_size).ceil
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

    def character_images
      @char_masks = {}
      characters.map.with_index do |char, index|
        image = text_image(char)
        mask = bitmask(image)
        yield(char, image, mask, index) if block_given?
        @char_masks[char] = mask
      end
      @char_masks
    end

    def char_masks
      @char_masks || character_images
    end

    def trie
      @trie ||= Trie.new(char_masks)
    end

    def parse_mask(columns)
      trie.recognize(columns)
    end

    def parse_image(img)
      parse_mask(bitmask(img))
    end

    def uppercase
      @uppercase ||= Set.new('A'..'Z')
    end

    def lowercase
      @lowercase ||= Set.new('a'..'z')
    end

    def digits
      @digits ||= Set.new('0'..'9')
    end

    def alphanumeric
      @alphanumeric ||= uppercase | lowercase | digits
    end

    def whitespace
      Set.new([' ',"\r","\n","\t"])
    end

    def symbols
      @symbols ||= characters - alphanumeric - whitespace
    end
  end
end
