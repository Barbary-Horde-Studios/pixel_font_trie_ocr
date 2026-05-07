# frozen_string_literal: true

require_relative "lib/pixel_font_trie_ocr/version"

Gem::Specification.new do |spec|
  spec.name = "pixel_font_trie_ocr"
  spec.version = PixelFontTrieOCR::VERSION
  spec.authors = ["Robert Ferney"]
  spec.email = ["rob@ferney.org"]

  spec.summary = "Deterministic OCR for tiny pixel fonts using a Trie of column bitmasks"
  spec.description = <<~DESC
    Provides perfect accuracy and microsecond performance for crystal-clear,
    5-8px pixel fonts by building a trie from font glyphs and matching image
    column bitmasks.
  DESC
  spec.homepage = "https://github.com/Barbary-Horde-Studios/pixel_font_trie_ocr"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Barbary-Horde-Studios/pixel_font_trie_ocr"
  spec.metadata["changelog_uri"] = "https://github.com/Barbary-Horde-Studios/pixel_font_trie_ocr/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .gitlab-ci.yml .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "ttfunk", "~> 1.8"
  spec.add_development_dependency "rmagick", "~> 6.3"
  spec.add_development_dependency "rspec", "~> 3.13"
  spec.add_development_dependency "rubocop", "~> 1.65"
  spec.add_development_dependency "simplecov", "~> 0.22"
  spec.add_development_dependency "vips", "~> 8.15"
end
