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
        char, idx = children[columns[index]]&.match(columns, index + 1)
        return [char, idx] if char

        [character, index]
      end
    end
  end
end
