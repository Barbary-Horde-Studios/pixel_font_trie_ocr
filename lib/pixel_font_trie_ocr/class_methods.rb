# frozen_string_literal: true

module ClassMethods
  def vips?
    @vips ||= defined?(Vips)
  end

  def magick?
    @magick ||= defined?(Magick)
  end

  def libs
    @libs ||=
      begin
        libs = []
        libs.push :magick if magick?
        libs.push :vips if vips?
        libs
      end
  end
end
