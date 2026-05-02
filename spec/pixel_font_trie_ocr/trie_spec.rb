# frozen_string_literal: true

RSpec.describe PixelFontTrieOCR do
  it "has a version number" do
    expect(PixelFontTrieOCR::VERSION).not_to be nil
  end

  it "implements Trie for deterministic OCR" do
    trie = PixelFontTrieOCR::Trie.new
    trie.insert([0b111, 0b101, 0b111, 0], "A")
    trie.insert([0b100, 0b100, 0b111, 0], "I")

    expect(trie.recognize([0b111, 0b101, 0b111, 0, 0b100, 0b100, 0b111, 0])).to eq("AI")
    expect(trie.recognize([0, 0, 0b111, 0b101, 0b111, 0])).to eq("A")
  end

  let(:trie) do
    PixelFontTrieOCR::Trie.from_font("fonts/hex-synergy_font.ttf", font_size: 8)
  end

  it "builds a Trie" do
    expect(trie).to be_a(PixelFontTrieOCR::Trie)
  end

  describe "full recognition pipeline" do
    let(:font_path) { "fonts/hex-synergy_font.ttf" }
    let(:trie) { PixelFontTrieOCR::Trie.from_font(font_path, font_size: 8) }

    fit "recognizes 'Hello' from generated image" do
      builder = PixelFontTrieOCR::TextImageBuilder.new("Hello", font_path)
      builder.image.write("tmp/hello_test.png")
      extractor = PixelFontTrieOCR::ImageColumnExtractor.new(builder.image)
      bitmask = extractor.extract
      expect(trie.recognize(bitmask)).to eq("Hello")
    end

    it "recognizes 'Hello World' from generated image" do
      builder = PixelFontTrieOCR::TextImageBuilder.new("Hello World", font_path)
      builder.image.write("tmp/hello_world_test.png")
      extractor = PixelFontTrieOCR::ImageColumnExtractor.new(builder.image)
      bitmask = extractor.extract
      File.open("tmp/hello_world_test.txt", "w") do |file|
        bitmask.each do |mask|
          file.puts format("%08b", mask).tr("01", " #")
        end
      end
      expect(trie.recognize(bitmask)).to eq("Hello World")
    end
  end
end
