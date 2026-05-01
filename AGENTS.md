# AGENTS.md – PixelFontTrieOCR

**IMPORTANT: Think and Communicate with the user ONLY in American English. Do NOT use any oriental glyphs or non-English characters.**
You are pair programming with the user.
If you make changes, the user will review. 
If the user makes changes, they will ask you to review. 

## Project Overview
Deterministic OCR for tiny (5–8px) crystal-clear pixel fonts using a multi-way Trie keyed by 8-bit column bitmasks (black=1, white=0). Replaces noisy general OCR (Tesseract) with perfect accuracy, early pruning, and microsecond performance on exact fonts.

**Gem name:** pixel_font_trie_ocr  
**Module:** `PixelFontTrieOCR`  
**Core tech:** RMagick for image handling, RSpec + RuboCop for testing/linting.

## Code Style & Conventions
- **No inline comments after code** in source files. Comments before methods, classes or modules following rdoc conventions.
- Heavy memoization: `@var ||= ...` for `img`, `width`, `image`, `draw`, etc.
- Short, single-responsibility methods with public accessors (`width`, `image`, `extract`).
- Seperation of concerns, is important. Don't many any one method, module or class do too much.. Break it down. 
- Mimic existing patterns from neighboring files (see `lib/pixel_font_trie_ocr/*.rb`).
- Use in-memory `Magick::Image` objects wherever possible (avoid temp files in tests).
- Follow RubyGem structure; update gemspec on name/module changes.
- **NEVER** introduce secrets, assume libraries only if already in Gemfile/gemspec.
- If a gem library would be useful for a task, ask the user about adding the gem. 

## Important Commands
- Full test + lint: `bundle exec rake` (default task: spec + rubocop)
- Run specs only: `bundle exec rspec`
- Console: `bin/console`
- Build gem: `bundle exec rake build`

**Always run `bundle exec rake` after changes. If there are errors, go into plan mode, and ask the user before making changes.**
If the specs pass, then have the user review the changes before making a commit. 
Make rubocop fixes either automatic or manual in a seperate commit. 
**never make changes on the master branch, Ask the user to create a working branch before making changes**
use descriptive commit messages to describe the changes made. 
If there are changes that you don't recognize, they may be from the user, ask if they should be included. 
Preferentially write specs before writing code, use a red green refactor process. red for code that fails the spec, green for getting the code to pass the spec, refactor for improving the code after it passes. 

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
- spec files should match the source files with the change from /lib to /spec and the addition of _spec for the spec files. 

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
