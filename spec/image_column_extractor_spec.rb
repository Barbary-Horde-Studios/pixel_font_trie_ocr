# frozen_string_literal: true

# spec/image_column_extractor_spec.rb
require "spec_helper"
require "fileutils"

RSpec.describe PixelFontTrieOCR::ImageColumnExtractor do
  let(:test_image_path) { "spec/fixtures/test_column.png" }

  before(:all) do
    FileUtils.mkdir_p("spec/fixtures")
  end

  after(:each) do
    File.delete(test_image_path) if File.exist?(test_image_path)
  end

  describe "#get_column" do
    it "returns correct mask for full black column" do
      PixelFontTrieOCR::ColumnImageBuilder.new([255]).write(test_image_path)
      extractor = described_class.new(test_image_path)
      expect(extractor.get_column(0)).to eq(255)
    end

    it "returns correct mask for full white column" do
      PixelFontTrieOCR::ColumnImageBuilder.new([0]).write(test_image_path)
      extractor = described_class.new(test_image_path)
      expect(extractor.get_column(0)).to eq(0)
    end

    it "correctly extracts individual bits" do
      mask = 0b01010101
      PixelFontTrieOCR::ColumnImageBuilder.new([mask]).write(test_image_path)
      extractor = described_class.new(test_image_path)
      expect(extractor.get_column(0)).to eq(mask)
    end
  end

  describe "exhaustive test" do
    it "handles all 256 possible 8-bit patterns" do
      all_masks = (0..255).to_a
      PixelFontTrieOCR::ColumnImageBuilder.new(all_masks).write(test_image_path)

      extractor = described_class.new(test_image_path)
      all_masks.each_with_index do |expected, col|
        expect(extractor.get_column(col)).to eq(expected)
      end
    end
  end
end
