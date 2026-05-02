# frozen_string_literal: true

require "rmagick"
require "ttfunk"
require_relative "pixel_font_trie_ocr/version"
require_relative "pixel_font_trie_ocr/methods"

class PixelFontTrieOCR
  class Error < StandardError; end
  include Methods
  extend Methods
  # Your code goes here...
end
