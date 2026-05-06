# frozen_string_literal: true

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

      def match(columns, index)
        if index < columns.length
          child_char, child_idx = children[columns[index]]&.match(columns, index + 1)
          return [child_char, child_idx] if child_char
        end

        [character, index]
      end
    end
  end
end
