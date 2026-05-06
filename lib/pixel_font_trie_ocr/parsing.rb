# frozen_string_literal: true

require_relative "trie"

class PixelFontTrieOCR
  module Parsing
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
      trie.parse(columns)
    end

    def parse_image(img)
      parse_mask(bitmask(img))
    end
  end
end
