# frozen_string_literal: true

require "rmagick"
require "ttfunk"
require_relative "pixel_font_trie_ocr/version"
require_relative "pixel_font_trie_ocr/methods"
require_relative "pixel_font_trie_ocr/font_metadata"
require_relative "pixel_font_trie_ocr/image_utils"
require_relative "pixel_font_trie_ocr/parsing"
require_relative "pixel_font_trie_ocr/image_column_extractor"

class PixelFontTrieOCR
  class Error < StandardError; end
  include Methods
  include FontMetadata
  include ImageUtils
  include Parsing
end
