# frozen_string_literal: true

require_relative "trie"

class PixelFontTrieOCR
  module Parsing
    def character_images
      @char_masks = {}
      parseable_characters.map.with_index do |char, index|
        if char == " "
          mask = [0, 0]
        else
          image = text_image(char)
          mask = bitmask(image)
          yield(char, image, mask, index) if block_given?
        end
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
      trie.parse(columns)
    end

    def magick_image?(image)
      magick? && image.is_a?(Magick::Image)
    end

    def vips_image?(image)
      vips? && image.is_a?(Vips::Image)
    end

    def parse_image(image)
      parse_mask(bitmask(image))
    end

    def bitmask(image)
      if magick_image? image
        MagickColumnExtractor.new(image).extract
      elsif vips_image? image
        VipsColumnExtractor.new(image).extract
      else
        raise Error, "unknown image class #{image.class.name}"
      end
    end
  end
end
