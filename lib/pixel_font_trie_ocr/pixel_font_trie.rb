# frozen_string_literal: true

# lib/pixel_font_trie_ocr/pixel_font_trie.rb
require "rmagick"
require_relative "image_column_extractor"
require_relative "text_image_builder"

module PixelFontTrieOCR
  class PixelFontTrie
    class Node
      attr_accessor :children, :character

      def initialize
        @children = {}
        @character = nil
      end
    end

    def initialize
      @root = Node.new
    end

    def insert(columns, character)
      node = @root
      columns.each do |mask|
        node.children[mask] ||= Node.new
        node = node.children[mask]
      end
      node.character = character
      self
    end

    def recognize(columns)
      result = []
      node = @root
      i = 0
      while i < columns.length
        mask = columns[i]
        if mask.zero?
          i += 1
          node = @root
          next
        end

        if (child = node.children[mask])
          node = child
          i += 1
          if node.character
            result << node.character
            node = @root
          end
        else
          i += 1
          node = @root
        end
      end
      result.join
    end

    def self.from_font(font_path, characters: nil, font_size: 8, height: 8)
      trie = new
      chars = characters || "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!?., "
      chars.each_char do |char|
        next if char.strip.empty? && char != " "

        builder = TextImageBuilder.new(char, font_path, font_size: font_size, height: height)
        extractor = ImageColumnExtractor.new(builder.image, height_limit: height)
        columns = extractor.extract
        trimmed = trim_columns(columns)
        trie.insert(trimmed, char)
      end
      trie
    end

    def self.trim_columns(columns)
      return columns if columns.empty?

      start_idx = columns.index { |m| m != 0 } || 0
      end_idx = columns.rindex { |m| m != 0 } || (columns.size - 1)
      columns[start_idx..end_idx]
    end
  end
end
