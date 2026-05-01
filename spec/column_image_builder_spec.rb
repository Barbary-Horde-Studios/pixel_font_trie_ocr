# frozen_string_literal: true

# spec/column_image_builder_spec.rb
require "spec_helper"

RSpec.describe PixelFontTrieOCR::ColumnImageBuilder do
  describe "image generation" do
    it "creates image with correct dimensions" do
      builder = described_class.new([255, 0, 42], height: 8)
      img = builder.image

      expect(img.columns).to eq(3)
      expect(img.rows).to eq(8)
    end

    it "draws black and white columns correctly" do
      builder = described_class.new([255, 0])
      img = builder.image

      pixels_black = img.get_pixels(0, 0, 1, 8)
      pixels_white = img.get_pixels(1, 0, 1, 8)

      expect(pixels_black.all? { |p| p.red == 0 }).to be true
      expect(pixels_white.all? { |p| p.red == 65_535 }).to be true
    end
  end
end
