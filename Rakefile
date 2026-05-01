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
  height = ENV.fetch("HEIGHT", 8).to_i

  require "pixel_font_trie_ocr"

  generator = PixelFontTrieOCR::GlyphImageGenerator.new(
    font_path,
    font_size: font_size,
    height: height,
    output_dir: output_dir
  )
  generator.generate
end

task default: %i[spec rubocop]
