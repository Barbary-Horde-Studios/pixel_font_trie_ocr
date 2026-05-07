# frozen_string_literal: true

require "vips" # Make sure ruby-vips is in your Gemfile for this spec

RSpec.describe "Hello World with Vips::Image" do
  let(:pft) { PixelFontTrieOCR.new }
  let(:hello_world) { "Hello World" }
  let(:temp_filename) { Pathname.new(__dir__).join("..", "tmp", "hello_world.png").to_s }

  # Generate the reference image using the library's built-in renderer (RMagick)
  let(:reference_image) { pft.text_image(hello_world) }
  let(:vips_bitmask) { pft.bitmask(vips_image) }
  let(:result) { pft.parse_image(vips_image) }
  let(:magick_bitmask) { pft.bitmask(reference_image) }

  shared_examples "parses correctly" do
    it "parses correctly using a Vips image source" do
      expect(result).to eq(hello_world)
    end

    it "produces the same bitmasks as the original RMagick path" do
      expect(vips_bitmask).to eq(magick_bitmask)
    end

    it "writes" do
      vips_image.write_to_file(vips_filename)
    end
  end

  context "memory buffer" do
    let(:vips_filename) { Pathname.new(__dir__).join("..", "tmp", "hello_world-vips.png").to_s }
    # Convert to Vips::Image (this is the key part)
    let(:vips_image) do
      # One clean way: save to memory buffer then load with Vips
      buffer = reference_image.to_blob { |img| img.format = "PNG" }
      Vips::Image.new_from_buffer(buffer, "")
    end

    include_examples "parses correctly"
  end

  context "temp_file" do
    let(:vips_filename) { Pathname.new(__dir__).join("..", "tmp", "hello_world_vips.png").to_s }
    let(:vips_image) do
      reference_image.write(temp_filename)
      Vips::Image.new_from_file(temp_filename)
    end

    include_examples "parses correctly"
  end

  context "generated image" do
    let(:vips_filename) { Pathname.new(__dir__).join("..", "tmp", "hello_world_vips-g.png").to_s }
    let(:vips_image) do
      pft.vips_image("Hello World")
    end

    include_examples "parses correctly"
  end
end
