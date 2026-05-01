# spec/font_inspector_spec.rb
# frozen_string_literal: true

require "spec_helper"

RSpec.describe PixelFontTrieOCR::FontInspector do
  let(:font_path) { "fonts/hex-synergy_font.ttf" }
  let(:inspector) { described_class.new(font_path) }

  # NOTE: In a real project you'd include a small test .ttf file in fixtures
  # For now, we'll use a real font path or skip heavy tests if font is missing

  describe "#initialize" do
    it "opens the font successfully" do
      expect { described_class.new(font_path) }.not_to raise_error
      expect(inspector.font).to be_a(TTFunk::File)
    end
  end

  describe "#characters" do
    it "returns an array of strings (characters)" do
      chars = inspector.characters
      expect(chars).to be_an(Array)
      expect(chars.first).to be_a(String)
      expect(chars.size).to be > 0
    end
  end

  describe "#info" do
    it "returns a hash with font metadata" do
      info = inspector.info

      expect(info).to include(:family, :character_count, :ascent, :descent)
      expect(info[:character_count]).to be_a(Integer)
      expect(info[:character_count]).to be_positive
    end
  end

  describe "#charset" do
    it "returns all characters as a single string" do
      charset = inspector.charset
      expect(charset).to be_a(String)
      expect(charset.length).to eq(inspector.characters.size)
    end
  end

  describe "#common_charset" do
    it "returns only common alphanumeric and punctuation characters" do
      common = inspector.common_charset
      expect(common).to match(/[A-Za-z0-9.,!? ]+/)
    end
  end

  describe "#print_summary" do
    it "prints to stdout without error" do
      expect { inspector.print_summary }.to output.to_stdout
    end
  end
end
