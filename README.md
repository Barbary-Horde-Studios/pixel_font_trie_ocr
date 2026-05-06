# PixelFontTrieOCR

**Deterministic OCR for tiny (5–8px) crystal-clear pixel fonts using a multi-way Trie keyed by 8-bit column bitmasks.**

Replaces noisy general OCR (e.g., Tesseract) with perfect accuracy, early pruning, and microsecond performance on exact fonts.

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

**Dependencies**: Requires RMagick for image handling and TTFunk for font parsing.

## Quick Start

```ruby
require 'pixel_font_trie_ocr'

ocr = PixelFontTrieOCR.new
ocr.font_name = 'hex-synergy_font.ttf'  # Default font
ocr.font_size = 8  # Default size

# Render text to image
img = ocr.text_image('Hello World')

# Extract column bitmasks
masks = ocr.bitmask(img)

# Recognize text
text = ocr.parse_mask(masks)
puts text  # => "Hello World"

# Or directly parse an image
text = ocr.parse_image(img)
```

## Advanced Usage

### Building and Using the Trie

```ruby
ocr = PixelFontTrieOCR.new

# Generate character masks from font (memoized)
char_masks = ocr.char_masks  # { 'A' => [mask1, mask2, ...], ... }

# Build trie
trie = ocr.trie  # Or PixelFontTrieOCR::Trie.new(char_masks)

# Insert custom character
trie.insert('!', [0b101, 0b010])

# Parse masks
masks = [0b101, 0b010, 0]  # Example masks with trailing zero
text = trie.parse(masks)  # Handles variable-width and whitespace
```

### Image Manipulation

```ruby
# Create image from masks
mask_img = ocr.mask_image(masks)

# Write text image to file
ocr.write_text_image('Test', 'test.png')

# Bitmask utilities
bitmask = ocr.array_to_bitmask([1, 0, 1])  # => 5
bits = ocr.bitmask_to_array(5)  # => [1, 0, 1]
```

### Custom Font Configuration

```ruby
ocr.font_dir = '/path/to/fonts'
ocr.font_name = 'custom_font.ttf'
ocr.font_size = 6

puts ocr.height  # Calculated pixel height
puts ocr.characters.to_a  # Supported characters
```

### Extracting Masks from Existing Image

```ruby
img = Magick::Image.read('path/to/image.png').first
extractor = PixelFontTrieOCR::ImageColumnExtractor.new(img, threshold: 50000)
masks = extractor.extract
```

## Features

- **Deterministic Recognition**: 100% accuracy for exact pixel matches; no ML heuristics.
- **Fast**: Microsecond per character; early trie pruning.
- **Variable-Width Support**: Handles fonts with varying glyph widths.
- **Memoization**: Heavy use for performance (e.g., font loading, mask generation).
- **Utilities**: Image rendering, bitmask conversion, font metadata extraction.
- **Customization**: Adjustable threshold for black/white detection in images.

## Core Components

| Component                  | Purpose |
|----------------------------|---------|
| `PixelFontTrieOCR`         | Main class including all modules; entry point for usage. |
| `Trie`                     | Core trie for inserting masks and parsing text. |
| `Trie::Node`               | Trie nodes with recursive matching. |
| `ImageColumnExtractor`     | Converts images to bitmask arrays. |
| `FontMetadata` (module)    | Font loading and metadata (characters, ascent, etc.). |
| `ImageUtils` (module)      | Image creation and writing (text_image, mask_image). |
| `Parsing` (module)         | Builds trie and performs recognition (parse_image). |
| `Methods` (module)         | Bitmask utilities (array_to_bitmask). |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests.

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Rake Tasks

- `rake spec`: Run RSpec tests.
- `rake rubocop`: Run RuboCop linter.
- `rake font_map`: Generate glyph images and YAML mask map to `/tmp/`.
- `rake build`: Build the gem.
- `rake install`: Install locally.
- `rake release`: Tag and publish to RubyGems.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[YOUR_USERNAME]/pixel_font_trie_ocr. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[YOUR_USERNAME]/pixel_font_trie_ocr/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
