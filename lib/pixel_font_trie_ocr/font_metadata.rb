# frozen_string_literal: true

require "ttfunk"

class PixelFontTrieOCR
  module FontMetadata
    DEFAULT_FONT_NAME = "hex-synergy_font.ttf"
    attr_writer :font_name, :font_size

    def font_name
      @font_name ||= DEFAULT_FONT_NAME
    end

    def font_dir=(value)
      @font_dir = Pathname.new(value)
    end

    def font_dir
      @font_dir ||= Pathname.new(__dir__).join("fonts")
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

    def uppercase
      @uppercase ||= Set.new("A".."Z") & characters
    end

    def lowercase
      @lowercase ||= Set.new("a".."z") & characters
    end

    def digits
      @digits ||= Set.new("0".."9") & characters
    end

    def alphanumeric
      @alphanumeric ||= uppercase | lowercase | digits
    end

    def whitespace
      Set.new([" ", "\r", "\n", "\t"])
    end

    def symbols
      @symbols ||= characters - alphanumeric - whitespace
    end

    def parseable_characters
      @parseable_characters ||= alphanumeric | symbols | [" "]
    end
  end
end
