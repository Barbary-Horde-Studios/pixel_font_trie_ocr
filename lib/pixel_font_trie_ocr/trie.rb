# frozen_string_literal: true

# lib/pixel_font_trie_ocr/trie.rb

class PixelFontTrieOCR
  class Trie
    class Node
      attr_accessor :children, :character

      def initialize
        @children = {}
        @character = nil
      end

      def leaf?
        children.empty?
      end
    end

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

    def recognize(columns)
      result = []
      node = root
      columns.each do |mask|
        if (child = node.children[mask])
          node = child
          if node.character
            result << node.character
            node = root
          end
        else
          node = root
        end
      end
      result.join
    end
  end
end
