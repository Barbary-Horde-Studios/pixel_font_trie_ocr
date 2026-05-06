# frozen_string_literal: true

# lib/pixel_font_trie_ocr/trie.rb
require_relative "trie/node"

class PixelFontTrieOCR
  class Trie
    def initialize(char_masks = {})
      insert_hash(char_masks)
    end

    def root
      @root ||= Node.new
    end

    def insert_hash(hash)
      hash.each_pair do |character, columns|
        insert(character, columns)
      end
    end

    def insert(character, columns)
      node = root
      columns.each do |mask|
        node.children[mask] ||= Node.new
        node = node.children[mask]
      end
      node.character ||= character
    end

    def parse(columns)
      columns = columns.dup
      columns << 0 unless columns.last.zero?
      match(columns)
    end

    protected

    def match(columns, pos = 0)
      return "" unless pos < columns.length

      matched, new_pos = root.match(columns, pos)
      if matched
        matched + match(columns, new_pos)
      else
        match(columns, pos + 1)
      end
    end
  end
end
