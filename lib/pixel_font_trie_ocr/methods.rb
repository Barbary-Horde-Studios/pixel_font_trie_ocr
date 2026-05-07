# frozen_string_literal: true

class PixelFontTrieOCR
  module Methods
    def magick?
      @magick ||= self.class.magick?
    end

    def vips?
      @vips ||= self.class.vips?
    end

    def libs
      @libs ||= self.class.libs
    end

    def lib=(sym)
      @lib = sym if libs.include? sym
    end

    def lib
      @lib ||= libs.first
    end

    def array_to_bitmask(array)
      array.inject(0) { |acc, bit| (acc << 1) | bit }
    end

    def bitmask_to_array(bitmask, length: nil)
      Array.new(length || bitmask.bit_length) { |i| (bitmask >> i) & 1 }
    end

    def initialize(**options)
      options.each_pair do |key, value|
        setter = "#{key}="
        send(setter, value) if respond_to? setter
      end
    end
  end
end
