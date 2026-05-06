# frozen_string_literal: true

class PixelFontTrieOCR
  module Methods
    def array_to_bitmask(array)
      array.inject(0) { |acc, bit| (acc << 1) | bit }
    end

    def bitmask_to_array(bitmask, length: nil)
      Array.new(length || bitmask.bit_length) { |i| (bitmask >> i) & 1 }
    end
  end
end
