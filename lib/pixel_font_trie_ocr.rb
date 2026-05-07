# frozen_string_literal: true

require "ttfunk"
require_relative "pixel_font_trie_ocr/version"
require_relative "pixel_font_trie_ocr/class_methods"
require_relative "pixel_font_trie_ocr/methods"
require_relative "pixel_font_trie_ocr/font_metadata"
require_relative "pixel_font_trie_ocr/image_utils"
require_relative "pixel_font_trie_ocr/parsing"
require_relative "pixel_font_trie_ocr/image_column_extractor"

begin
  require "rmagick"
  require_relative "pixel_font_trie_ocr/magick_utils"
  require_relative "pixel_font_trie_ocr/magick_column_extractor"
  MAGICK_AVAILABLE = true
rescue LoadError
  MAGICK_AVAILABLE = false
end

begin
  require "vips"
  require_relative "pixel_font_trie_ocr/vips_utils"
  require_relative "pixel_font_trie_ocr/vips_column_extractor"
rescue LoadError
  VIPS_AVAILABLE = false
end

class PixelFontTrieOCR
  class Error < StandardError; end
  class LibError < Error; end
  extend ClassMethods
  include Methods
  include FontMetadata
  include ImageUtils
  include Parsing
  include VipsUtils if vips?
  include MagickUtils if magick?
end
