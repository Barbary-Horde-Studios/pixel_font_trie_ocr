# frozen_string_literal: true

RSpec.describe "bad quotes" do
  let(:pft) { PixelFontTrieOCR.new }
  let(:bitmask) { |example| example.metadata[:mask] }

  it "parses as as a single quote", mask: [24, 0] do
    expect(pft.parse_mask(bitmask)).to eq("'")
  end

  it "parses as as a double quote", mask: [24, 0, 24] do
    expect(pft.parse_mask(bitmask)).to eq('"')
  end

  it "parses as as a double quote", mask: [24, 0, 24, 0] do
    expect(pft.parse_mask(bitmask)).to eq('"')
  end

  it "parses as two single quotes", mask: [24, 0, 0, 24, 0] do
    expect(pft.parse_mask(bitmask)).to eq("''")
  end

  it "parses as two single quotes period", mask: [24, 0, 0, 24, 0, 1, 0] do
    expect(pft.parse_mask(bitmask)).to eq("''.")
  end

  it "parses as ' '", mask: [24, 0, 0, 0, 24, 0] do
    expect(pft.parse_mask(bitmask)).to eq("' '")
  end
end
