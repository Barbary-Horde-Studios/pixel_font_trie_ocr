# frozen_string_literal: true

RSpec.describe PixelFontTrieOCR do
  it "has a version number" do
    expect(PixelFontTrieOCR::VERSION).not_to be nil
  end

  it "implements PixelFontTrie for deterministic OCR" do
    trie = PixelFontTrieOCR::PixelFontTrie.new
    trie.insert([0b111, 0b101, 0b111], "A")
    trie.insert([0b100, 0b100, 0b111], "I")

    expect(trie.recognize([0b111, 0b101, 0b111, 0, 0b100, 0b100, 0b111])).to eq("AI")
    expect(trie.recognize([0, 0, 0b111, 0b101, 0b111, 0])).to eq("A")

    built = PixelFontTrieOCR::PixelFontTrie.from_font(
      "fonts/hex-synergy_font.ttf",
      characters: "A",
      font_size: 8
    )
    expect(built).to be_a(PixelFontTrieOCR::PixelFontTrie)
  end
end
