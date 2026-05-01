# frozen_string_literal: true

# FontInspector reads a TrueType font file and provides access to the
# glyphs and characters it contains. Used to discover available characters
# for building a PixelFontTrie charset.
require "ttfunk"

module PixelFontTrieOCR
  # Inspects a font file to list its supported characters and metadata
  class FontInspector
    attr_reader :font_path

    def initialize(font_path)
      @font_path = font_path
    end

    def font
      @font ||= TTFunk::File.open(font_path)
    end

    def unicode_cmap
      @unicode_cmap ||= font.cmap.unicode.first || []
    end

    def character(point)
      glyph_id = unicode_cmap[point]
      [point].pack("U") if glyph_id&.positive?
    rescue StandardError
      nil
    end

    def character_list
      @character_list ||= (0..0xFFFF).filter_map { |point| character(point) }
    end

    # Returns a string of all characters supported by the font
    def characters
      @characters ||= character_list.join
    end

    # Returns a hash of font metadata
    def info
      @info ||= {
        family: family,
        subfamily: subfamily,
        postscript_name: postscript_name,
        character_count: character_count,
        ascent: ascent,
        descent: descent,
        units_per_em: units_per_em
      }
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

    # Print a friendly summary
    def print_summary
      puts "Font: #{postscript_name || family}"
      puts "Characters supported: #{character_count}"
      puts "Sample characters: #{characters.chars.first(50).join(" ")}"
      puts "\nFull info:"
      info.each do |key, value|
        puts "  #{key}: #{value}"
      end
    end

    # Filter to common characters only (optional)
    def common_charset
      characters.chars.select { |c| c.match?(/[A-Za-z0-9.,!? ]/) }.join
    end
  end
end
