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
      early = nil
      last = 0
      index = 0
      columns.push(0) unless columns.last.zero?
      while (index < columns.size)
        mask = columns[index]
        if (child = node.children[mask]) # can we descend?
          node = child # descend tree
          if node.children.empty? # leaf node
            if node.character # leaf match
              result << node.character # add leaf node character
            elsif early # no match check for early match
              result << early # add earlier match
              early = nil
              index = last # backup to where we matched
            else # else leaf without either match or early match
              # dead end
            end
            node = root # reset to beginning of tree
            early = nil # clear early match if any
          elsif node.character # non leaf match
            early = node.character
            last = index
          end
        elsif early # no descent with early match
          result << early # add earlier match
          early = nil
          index = last # backup to where we matched
        else # no character matches mask 
          index = last
          last += 1 ## failed match try next column
          node = root
        end
        index += 1 # next column mask in image
      end
      if node != root && early
        result << early
      end
      result.join
    end
  end
end
