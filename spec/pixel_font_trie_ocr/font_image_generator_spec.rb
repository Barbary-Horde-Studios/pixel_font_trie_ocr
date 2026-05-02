# spec/pixel_font_trie_ocr/font_image_generator_spec.rb
# Tests for FontImageGenerator which generates images and bitmasks
# for each glyph defined in the font.
# frozen_string_literal: true

require "spec_helper"

RSpec.describe PixelFontTrieOCR::FontImageGenerator do
  let(:font_path) { "fonts/hex-synergy_font.ttf" }
  let(:generator) { described_class.new(font_path) }

  describe "#initialize" do
    it "creates a generator successfully" do
      expect { described_class.new(font_path) }.not_to raise_error
      expect(generator.font_path).to eq(font_path)
    end
  end

  describe "#inspector" do
    it "returns a FontInspector instance" do
      expect(generator.inspector).to be_a(PixelFontTrieOCR::FontInspector)
    end
  end

  describe "#characters" do
    it "returns characters from the font" do
      expect(generator.characters).to be_an(Array)
      expect(generator.characters).to include("A")
      expect(generator.characters.size).to eq(84)
    end
  end

  describe "#pixel_height" do
    it "returns the calculated pixel height" do
      expect(generator.pixel_height).to eq(7)
    end
  end

  describe "#generate" do
    it "returns an array of Map objects with char, image, and bitmask" do
      result = generator.generate
      expect(result).to be_an(Array)
      expect(result.first).to be_a(PixelFontTrieOCR::FontImageGenerator::Map)
      expect(result.first.char).not_to be_nil
      expect(result.first.image).not_to be_nil
      expect(result.first.bitmask).not_to be_nil
    end

    it "includes data for known characters like A" do
      result = generator.generate
      entry = result.find { |m| m.char == "A" }
      expect(entry).to be_a(PixelFontTrieOCR::FontImageGenerator::Map)
      expect(entry.image).to be_a(Magick::Image)
      expect(entry.bitmask).to be_an(Array)
    end

    it "generates correct bitmask for a character" do
      result = generator.generate
      entry = result.find { |m| m.char == "A" }
      expect(entry.bitmask).to be_an(Array)
      expect(entry.bitmask.first).to be_an(Integer)
    end
  end
end
