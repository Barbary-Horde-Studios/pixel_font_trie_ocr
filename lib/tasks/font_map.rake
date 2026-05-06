desc "Generate font glyph images and bitmask map to tmp/font/"
task :font_map do
  require "yaml"
  word = /[A-Za-z0-9]/
  pft = PixelFontTrieOCR.new
  pft.temp_dir.mkpath

  map_data = pft.character_images
  File.write("tmp/map.yaml", map_data.to_yaml)
  puts "Generated #{map_data.size}"

  pft.write_text_image(pft.uppercase.join, "uppercase.png")
  pft.write_text_image(pft.lowercase.join, "lowercase.png")
  pft.write_text_image(pft.digits.join, "digits.png")
  pft.write_text_image(pft.symbols.join, "symbols.png", pad: 10)
end
