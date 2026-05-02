# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"
require "fileutils"

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

desc "Generate glyph images from font to tmp/glyphs"
task :generate_glyphs do
  font_path = ENV.fetch("FONT_PATH", "fonts/hex-synergy_font.ttf")
  output_dir = ENV.fetch("OUTPUT_DIR", "tmp/glyphs")
  font_size = ENV.fetch("FONT_SIZE", 8).to_i

  require "pixel_font_trie_ocr"

  generator = PixelFontTrieOCR::GlyphImageGenerator.new(
    font_path,
    font_size: font_size,
    output_dir: output_dir
  )
  generator.generate
end

desc "Generate font glyph images and bitmask map to tmp/font/"
task :generate_font_map do
  font_path = ENV.fetch("FONT_PATH", "fonts/hex-synergy_font.ttf")
  output_dir = ENV.fetch("OUTPUT_DIR", "tmp/font")
  font_size = ENV.fetch("FONT_SIZE", 8).to_i

  require "pixel_font_trie_ocr"
  require "yaml"

  FileUtils.mkdir_p(output_dir)

  generator = PixelFontTrieOCR::FontImageGenerator.new(
    font_path,
    font_size: font_size
  )

  result = generator.generate
  map_data = []
  images_dir = File.join(output_dir, "images")
  FileUtils.mkdir_p(images_dir)

  result.each do |entry|
    char = entry[:char]
    hex = char.ord.to_s(16).upcase
    filename = File.join(images_dir, "#{hex}.png")
    entry[:image].write(filename)
    map_data << { char: char, hex: hex, bitmask: entry[:bitmask] }
  end

  map_file = File.join(output_dir, "map.yaml")
  File.write(map_file, map_data.to_yaml)
  puts "Generated #{map_data.size} glyphs -> #{map_file}"
end

task default: %i[spec rubocop]
