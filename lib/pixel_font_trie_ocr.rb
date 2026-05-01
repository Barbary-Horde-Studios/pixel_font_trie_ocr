# frozen_string_literal: true

# lib/pixel_font_trie_ocr.rb
require "rmagick"
require_relative "pixel_font_trie_ocr/version"
require_relative "pixel_font_trie_ocr/image_column_extractor"
require_relative "pixel_font_trie_ocr/column_image_builder"
require_relative "pixel_font_trie_ocr/text_image_builder"
require_relative "pixel_font_trie_ocr/pixel_font_trie"
require_relative "pixel_font_trie_ocr/glyph_image_generator"
require_relative "pixel_font_trie_ocr/font_inspector"

module PixelFontTrieOCR
  class Error < StandardError; end
  # Your code goes here...
end
