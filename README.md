# PixelFontTrieOCR

**Deterministic, column-by-column Trie-based OCR for tiny, crystal-clear pixel fonts.**

Perfect for 5–8 pixel high generated fonts where Tesseract and other general OCR engines fail.

---

## Why Trie?

Most general-purpose OCR engines (like Tesseract) are designed for noisy, scanned, or anti-aliased text. They use machine learning, statistical models, and heavy preprocessing — which is overkill and often inaccurate for our use case.

We are working with **crystal-clear, pixel-perfect, tiny fonts** (typically 5–8 pixels high) generated directly from TrueType fonts. In this environment, a completely different approach is not only possible — it is far superior.

### The Trie (Prefix Tree) Advantage

We built a **multi-way trie** keyed by column bitmasks (8-bit integers):

- Each step in the trie represents one vertical column of pixels.
- Branching happens on the exact bitmask value of that column.
- Recognition is a simple left-to-right walk through the image.
- Early exit: most characters diverge after just 1–3 columns, so we stop immediately.
- 100% deterministic — no training, no floating point, no heuristics.

### Why This Is Perfect for Tiny Pixel Fonts

- Extremely fast (microseconds per character)
- Tiny memory footprint (a few KB for a full charset)
- Perfect accuracy on the exact font it was built for
- Naturally supports variable-width glyphs
- Easy to debug and reason about

**General OCR** = “guess what this blurry thing might be”  
**PixelFontTrieOCR** = “follow the exact pixel pattern until we reach a known character”

This is the right tool for the job.

---

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pixel_font_trie_ocr'
```
And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install pixel_font_trie_ocr
```

---

## Basic Usage

```ruby
require 'pixel_font_trie_ocr'

# Render text using your font
text_builder = PixelFontTrieOCR::TextImageBuilder.new(
  "Hello World", 
  "/path/to/your_font.ttf", 
  font_size: 8
)

img = text_builder.image

# Extract column bitmasks from an image
extractor = PixelFontTrieOCR::ImageColumnExtractor.new("sample_image.png")
masks = extractor.extract

puts "Extracted #{masks.size} column masks"
```

## Using the Trie

```ruby
# Build trie from your pixel font
trie = PixelFontTrieOCR::PixelFontTrie.from_font(
  "/path/to/your_pixel_font.ttf",
  characters: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!? ",
  font_size: 8
)

# Recognize text from column masks
masks = extractor.extract
text = trie.recognize(masks)
puts text  # => "HELLO WORLD"
```

The trie supports variable-width characters and skips whitespace columns automatically.

---

## Core Components

| Class                    | Purpose |
|-------------------------|--------|
| `ImageColumnExtractor`  | Converts images → array of 8-bit column masks |
| `ColumnImageBuilder`    | Creates test images from bitmask arrays |
| `TextImageBuilder`      | Renders text to clean pixel images using TrueType fonts |
| `PixelFontTrie`         | Core trie-based recognizer (`insert`, `recognize`, `from_font`) |

---

## Development

```bash
git clone <your-repo-url>
cd pixel_font_tree_ocr
bundle install
bundle exec rspec
```

---

## License

MIT License

