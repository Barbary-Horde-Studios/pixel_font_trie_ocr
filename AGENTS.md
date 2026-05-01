# AGENTS.md – PixelFontTrieOCR

**IMPORTANT: Communicate with the user ONLY in American English. Do NOT use any oriental glyphs or non-English characters.**

## Project Overview
Deterministic OCR for tiny (5–8px) crystal-clear pixel fonts using a multi-way Trie keyed by 8-bit column bitmasks (black=1, white=0). Replaces noisy general OCR (Tesseract) with perfect accuracy, early pruning, and microsecond performance on exact fonts.

**Gem name:** pixel_font_trie_ocr  
**Module:** `PixelFontTrieOCR`  
**Core tech:** RMagick for image handling, RSpec + RuboCop for testing/linting.

## Code Style & Conventions
- **No inline comments** in source files (file-header comments only).
- Heavy memoization: `@var ||= ...` for `img`, `width`, `image`, `draw`, etc.
- Short, single-responsibility methods with public accessors (`width`, `image`, `extract`).
- Mimic existing patterns from neighboring files (see `lib/pixel_font_trie_ocr/*.rb`).
- Use in-memory `Magick::Image` objects wherever possible (avoid temp files in tests).
- Follow RubyGem structure; update gemspec on name/module changes.
- **NEVER** introduce secrets, assume libraries only if already in Gemfile/gemspec.

## Important Commands
- Full test + lint: `bundle exec rake` (default task: spec + rubocop)
- Run specs only: `bundle exec rspec`
- Console: `bin/console`
- Build gem: `bundle exec rake build`

**Always run `bundle exec rake` after changes before committing.**

## Key Components
- `ImageColumnExtractor`: Path or `Magick::Image` → array of column masks (8-bit ints). Supports `height_limit`, `threshold`.
- `ColumnImageBuilder`: Masks + height → test image (`#image`, `#write`).
- `TextImageBuilder`: Text + TTF font → clean pixel image (`#image`, `#write`, memoized metrics).
- `PixelFontTrie`: 
  - `insert(columns, char)`
  - `recognize(columns)` (handles whitespace columns, variable-width glyphs)
  - `PixelFontTrie.from_font(font_path, characters: "...", font_size: 8)` (builds from TrueType, trims whitespace).

## Testing Approach
- RSpec in `spec/`.
- Use `ColumnImageBuilder` to generate fixtures (e.g. exhaustive 256-pattern column test).
- Prefer in-memory tests over real image files.
- `spec/pixel_font_trie_ocr_spec.rb` covers Trie behavior with synthetic masks.
- Update `spec/test_image_builder_spec.rb` font path for local testing (AdwaitaMono works for basic cases).

## Usage
```ruby
trie = PixelFontTrieOCR::PixelFontTrie.from_font("font.ttf", characters: "ABC123!?")
masks = PixelFontTrieOCR::ImageColumnExtractor.new(image).extract
puts trie.recognize(masks)
```

## Rake Tasks
- `bundle exec rake generate_glyphs` – Generate glyph images from font (default: `fonts/hex-synergy_font.ttf` → `tmp/glyphs/`).
  - Env vars: `FONT_PATH`, `OUTPUT_DIR`, `FONT_SIZE`, `HEIGHT`.
  - Uses `PixelFontTrieOCR::GlyphImageGenerator`.

## Next Steps (from project recap)
- Full recognition pipeline on real samples.
- CLI tool (`bin/pixel-font-trie-ocr`).
- Polish, release as gem.

Update this file when adding new commands, conventions, or architecture changes.
