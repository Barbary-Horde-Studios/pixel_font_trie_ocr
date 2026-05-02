desc "Generate font glyph images and bitmask map to tmp/font/"
task :font_map do
  require "yaml"
  word = /[A-Za-z0-9]/
  pft = PixelFontTrieOCR.new
  pft.temp_dir.mkpath

  images = {}
  map_data = pft.character_images do |char, image, mask, index|
    images[char] = image
  end
  images.each_pair do |char, image|
    result = pft.parse_image(image)
    puts "#{char} looks like #{result}" unless char == result
  end
  File.write("tmp/map.yaml", map_data.to_yaml)
  puts "Generated #{map_data.size}"

  pft.write_text_image(pft.uppercase.join, "uppercase.png")
  pft.write_text_image(pft.lowercase.join, "lowercase.png")
  pft.write_text_image(pft.digits.join, "digits.png")
  pft.write_text_image(pft.symbols.join, "symbols.png", pad: 10)

  image = pft.text_image('HELLO WORLD')
  image.write("tmp/hello_world_text.png")
  bitmask = pft.bitmask(image)
  bitimg = pft.mask_image(bitmask)
  bitimg.write("tmp/hello_world_mask.png")
  results = pft.parse_mask(bitmask)
  puts results
end

