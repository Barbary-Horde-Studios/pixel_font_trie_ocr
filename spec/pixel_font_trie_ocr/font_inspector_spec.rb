# spec/pixel_font_trie_ocr/font_inspector_spec.rb
# Tests for FontInspector which reads a font and provides a list of
# glyphs/characters that the font contains.
# frozen_string_literal: true

require "spec_helper"

RSpec.describe PixelFontTrieOCR::FontInspector do
  let(:font_path) { "fonts/hex-synergy_font.ttf" }
  let(:inspector) { described_class.new(font_path) }
  let(:defined_characters) { "\r !\"\#$%&'()*+,-./0123456789:=?@ABCDEFGHIJKLMNOPQRSTUVWXYZ^abcdefghijklmnopqrstuvwxyz" }
  let(:expected_info) do
    {
      family: [
        "\x00h\x00e\x00x\x00s\x00e\x00n\x00e\x00r\x00g\x00y\x00_\x00f\x00o\x00n" \
        "\x00t\x00 \x00R\x00e\x00g\x00u\x00l\x00a\x00r",
        "hexsenergy_font Regular",
        "\x00h\x00e\x00x\x00s\x00e\x00n\x00e\x00r\x00g\x00y\x00_\x00f\x00o" \
        "\x00n\x00t\x00 \x00R\x00e\x00g\x00u\x00l\x00a\x00r"
      ],
      subfamily: [
        "\x00R\x00e\x00g\x00u\x00l\x00a\x00r",
        "Regular",
        "\x00R\x00e\x00g\x00u\x00l\x00a\x00r"
      ],
      postscript_name: "hexsenergy_font",
      character_count: 84,
      ascent: 640,
      descent: 0,
      units_per_em: 1024
    }
  end

  # NOTE: Using hex-synergy_font.ttf as the test font - this is the actual font
  # we use for pixel font OCR. It defines 84 characters including alphanumeric,
  # common punctuation, and symbols.

  describe "#initialize" do
    it "opens the font successfully" do
      expect { described_class.new(font_path) }.not_to raise_error
      expect(inspector.font).to be_a(TTFunk::File)
    end
  end

  describe "#unicode_cmap" do
    it "returns a TTFunk::Table::Cmap::Subtable" do
      expect(inspector.send(:unicode_cmap)).to be_a(TTFunk::Table::Cmap::Subtable)
    end
  end

  describe "#character" do
    it "returns the character for a known codepoint" do
      # Codepoint 65 is "A"
      expect(inspector.send(:character, 65)).to eq("A")
    end

    it "returns nil for a codepoint not in the font" do
      # Use a high codepoint that is not in the font
      expect(inspector.send(:character, 99_999)).to be_nil
    end
  end

  describe "#character_list" do
    it "returns an array of strings" do
      expect(inspector.send(:character_list)).to be_an(Array)
      expect(inspector.send(:character_list).first).to be_a(String)
    end

    it "includes known characters like A" do
      expect(inspector.send(:character_list)).to include("A")
    end

    it "returns 84 characters" do
      expect(inspector.send(:character_list).size).to eq(84)
    end
  end

  describe "#characters" do
    # Returns a string of characters the font defines (not an array)
    it "returns a string of characters the font defines" do
      chars = inspector.characters
      expect(chars).to be_a(String)
      expect(chars).to eq(defined_characters)
    end
  end

  describe "#info" do
    # Returns a hash of font metadata (family, subfamily, postscript_name, etc.)
    it "returns a hash with font metadata matching expected values" do
      info = inspector.info

      expect(info).to eq(expected_info)
    end
  end

  describe "#family" do
    it "returns the font family name" do
      expect(inspector.family).to eq(expected_info[:family])
    end
  end

  describe "#subfamily" do
    it "returns the font subfamily" do
      expect(inspector.subfamily).to eq(expected_info[:subfamily])
    end
  end

  describe "#postscript_name" do
    it "returns the postscript name" do
      expect(inspector.postscript_name).to eq(expected_info[:postscript_name])
    end
  end

  describe "#character_count" do
    it "returns the number of characters" do
      expect(inspector.character_count).to eq(expected_info[:character_count])
    end
  end

  describe "#ascent" do
    it "returns the font ascent value" do
      expect(inspector.ascent).to eq(expected_info[:ascent])
    end
  end

  describe "#descent" do
    it "returns the font descent value" do
      expect(inspector.descent).to eq(expected_info[:descent])
    end
  end

  describe "#units_per_em" do
    it "returns the units per em value" do
      expect(inspector.units_per_em).to eq(expected_info[:units_per_em])
    end
  end

  describe "#num_glyphs" do
    it "returns the maximum glyph ID in the font" do
      expect(inspector.send(:num_glyphs)).to eq(84)
    end
  end

  describe "#common_charset" do
    it "returns only common alphanumeric and punctuation characters" do
      common = inspector.common_charset
      expect(common).to match(/[A-Za-z0-9.,!? ]+/)
      expect(common.chars.all? { |c| defined_characters.include?(c) }).to be true
    end
  end

  describe "#print_summary" do
    it "prints to stdout without error" do
      expect { inspector.print_summary }.to output.to_stdout
    end
  end
end
