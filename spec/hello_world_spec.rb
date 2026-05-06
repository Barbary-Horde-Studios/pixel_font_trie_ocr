RSpec.describe "Hello World" do
  let(:pft) { PixelFontTrieOCR.new }
  let(:hello_world) { "Hello World" }
  let(:image) { pft.text_image(hello_world) }
  let(:bitmask) { pft.bitmask(image) }
  let(:bitimg) { pft.mask_image(bitmask) }
  let(:result) { pft.parse_image(image) }

  it "parses" do
    expect(result).to eq(hello_world)
    expect(bitimg).to eq(image)
  end
end

