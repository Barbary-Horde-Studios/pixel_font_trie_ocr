# frozen_string_literal: true

# spec/pixel_font_trie_ocr/text_image_builder_spec.rb
require "spec_helper"

RSpec.describe PixelFontTrieOCR::TextImageBuilder do
  let(:font_path) { "fonts/hex-synergy_font.ttf" }

  it "creates an image from text" do
    builder = described_class.new("AB", font_path, font_size: 8)
    img = builder.image

    expect(img).to be_a(Magick::Image)
    expect(img.columns).to be > 0
    expect(img.rows).to eq(8)
  end

  it "memoizes the image" do
    builder = described_class.new("Test", font_path)
    first = builder.image
    expect(builder.image).to be(first)
  end
end
