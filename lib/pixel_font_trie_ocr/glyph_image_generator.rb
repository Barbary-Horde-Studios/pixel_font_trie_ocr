# frozen_string_literal: true

# lib/pixel_font_trie_ocr/glyph_image_generator.rb
require "fileutils"
require "rmagick"
require_relative "text_image_builder"

module PixelFontTrieOCR
  class GlyphImageGenerator
    attr_reader :font_path, :characters, :font_size, :height, :output_dir

    def initialize(font_path, characters: nil, font_size: 8, height: 8, output_dir: "tmp/glyphs")
      @font_path = font_path
      @characters = characters || default_characters
      @font_size = font_size
      @height = height
      @output_dir = output_dir
    end

    def generate
      FileUtils.mkdir_p(output_dir)

      characters.each_char do |char|
        next if char.strip.empty? && char != " "

        builder = TextImageBuilder.new(char, font_path, font_size: font_size, height: height)
        filename = File.join(output_dir, "#{char.ord.to_s(16)}.png")
        builder.write(filename)
        puts "Generated: #{filename}"
      end
    end

    private

    def default_characters
      "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!?., "
    end
  end
end
