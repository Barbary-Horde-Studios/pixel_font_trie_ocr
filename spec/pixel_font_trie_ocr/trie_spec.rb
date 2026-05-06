# frozen_string_literal: true

RSpec.describe PixelFontTrieOCR do
  it "has a version number" do
    expect(PixelFontTrieOCR::VERSION).not_to be nil
  end

  it "implements Trie for deterministic OCR" do
    trie = PixelFontTrieOCR::Trie.new
    trie.insert("A", [0b111, 0b101, 0b111, 0])
    trie.insert("I", [0b100, 0b100, 0b111, 0])

    expect(trie.recognize([0b111, 0b101, 0b111, 0, 0b100, 0b100, 0b111, 0])).to eq("AI")
    expect(trie.recognize([0, 0, 0b111, 0b101, 0b111, 0])).to eq("A")
  end
end
