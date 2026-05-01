# lib/pixel_font_trie/font_inspector.rb
# frozen_string_literal: true

require "ttfunk"

module PixelFontTrieOCR
  class FontInspector
    attr_reader :font_path

    def initialize(font_path)
      @font_path = font_path
    end

    def font
      @font = TTFunk::File.open(font_path)
    end

    # Returns an array of all characters supported by the font
    def characters
      @characters ||= begin
        unicode_cmap = font.cmap.unicode.first
        return [] unless unicode_cmap
        puts unicode_cmap

        unicode_cmap.entries.keys.map { |codepoint| [codepoint].pack("U") }
      end
    end

    # Returns a nice summary of the font
    def info
      {
        family: font.name.font_name,
        subfamily: font.name.font_subfamily,
        # full_name: font.name.full_name,
        postscript_name: font.name.postscript_name,
        character_count: characters.size,
        ascent: font.horizontal_metrics.ascent,
        descent: font.horizontal_metrics.descent,
        units_per_em: font.header.units_per_em
      }
    end

    # Print a friendly summary
    def print_summary
      puts "Font: #{info[:full_name] || info[:family]}"
      puts "Characters supported: #{info[:character_count]}"
      puts "Sample characters: #{characters.first(50).join(" ")}"
      puts "\nFull info:"
      info.each do |key, value|
        puts "  #{key}: #{value}"
      end
    end

    # Useful for building your Trie charset
    def charset
      characters.join
    end

    # Filter to common characters only (optional)
    def common_charset
      charset.chars.select { |c| c.match?(/[A-Za-z0-9.,!? ]/) }.join
    end
  end
end
