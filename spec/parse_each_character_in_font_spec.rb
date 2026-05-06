# frozen_string_literal: true

RSpec.describe "Parse Each Character in Font" do
  let(:pft) { PixelFontTrieOCR.new }
  let(:images) { {} }
  let(:masks) do
    pft.character_images do |char, image, _mask, _index|
      images[char] = image
    end
  end
  let(:mismatch) { {} }

  before do
    masks
    images.each_pair do |char, image|
      result = pft.parse_image(image)
      mismatch[char] = result unless char == result
    end
  end

  it "only has two mismatches" do
    expect(mismatch).to eq({ "S" => "5", "z" => "Z" })
  end
end
