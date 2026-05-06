# frozen_string_literal: true

require "spec_helper"

RSpec.describe PixelFontTrieOCR::Methods do
  let(:instance) { PixelFontTrieOCR.new }

  let(:defined_characters) do
    Set.new(
      " !\"\#$%&'()*+,-./0123456789:=?@ABCDEFGHIJKLMNOPQRSTUVWXYZ^abcdefghijklmnopqrstuvwxyz".chars
    )
  end

  describe "#font_name" do
    it "returns the set font name" do
      instance.font_name = "OtherFont.ttf"
      expect(instance.font_name).to eq("OtherFont.ttf")
    end

    it "defaults to DEFAULT_FONT_NAME" do
      expect(instance.font_name).to eq(PixelFontTrieOCR::Methods::DEFAULT_FONT_NAME)
    end
  end

  describe "#font_dir" do
    it "returns the set font dir" do
      instance.font_dir = "other_dir"
      expect(instance.font_dir.to_s).to eq("other_dir")
    end

    it "defaults to __dir__ / 'fonts'" do
      expect(instance.font_dir.to_s).to end_with("/pixel_font_trie_ocr/fonts")
    end
  end

  describe "#font_size" do
    it "returns the set font size" do
      instance.font_size = 10
      expect(instance.font_size).to eq(10)
    end

    it "defaults to 8" do
      expect(instance.font_size).to eq(8)
    end
  end

  describe "#font" do
    it "opens the font file" do
      expect(instance.font).to be_a(TTFunk::File)
    end
  end

  describe "#font_map" do
    it "returns the unicode cmap" do
      expect(instance.font_map).to be_a(TTFunk::Table::Cmap::Subtable)
    end
  end

  describe "#code_map" do
    it "returns the code map if available" do
      expect(instance.code_map).to be_a(Hash)
      expect(instance.code_map.size).to be > 0
    end
  end

  describe "#characters" do
    it "returns an array of supported characters" do
      expect(instance.characters).to be_an(Set)
      expect(instance.characters).to match_array(defined_characters)
    end
  end

  describe "#family" do
    it "returns the font family names" do
      expect(instance.family).to include("hexsenergy_font Regular")
    end
  end

  describe "#subfamily" do
    it "returns the font subfamily names" do
      expect(instance.subfamily).to include("Regular")
    end
  end

  describe "#postscript_name" do
    it "returns the postscript name" do
      expect(instance.postscript_name).to eq("hexsenergy_font")
    end
  end

  describe "#character_count" do
    it "returns the number of characters" do
      expect(instance.character_count).to eq(83)
    end
  end

  describe "#ascent" do
    it "returns the font ascent" do
      expect(instance.ascent).to eq(640)
    end
  end

  describe "#descent" do
    it "returns the font descent" do
      expect(instance.descent).to eq(0)
    end
  end

  describe "#units_per_em" do
    it "returns units per em" do
      expect(instance.units_per_em).to eq(1024)
    end
  end

  describe "#ascent_ratio" do
    it "returns ascent / units_per_em" do
      expect(instance.ascent_ratio).to eq(640 / 1024.0)
    end
  end
end
