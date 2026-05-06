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
      early_match = nil
      last_match_index = 0
      index = 0
      while (index < columns.size)
        mask = columns[index]
        if (child = node.children[mask])
          node = child # descend tree
          if node.children.empty? # leaf node
            if node.character # leaf match
              result << node.character
            elsif early_match # no match check for early match
              result << early_match
              index = last_match_index
            # else leaf without either match or early match
            end
            node = root
            early_match = nil
          elsif node.character # non leaf match
            early_match = node.character
            last_match_index = index
          end
        else # no character matches mask
          last_match_index += 1 ## failed match try next column
          index = last_match_index
          node = root
        end
        index += 1
      end
      if node != root && early_match
        result << early_match
      end
      result.join
    end
  end
end
