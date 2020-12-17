module Hemi::Render
  class Image
    ERR__INVALID_POSITION = "Ivalid position.".freeze

    @images   = {}

    def render(image, position: nil, size: nil, mode: :blended)
      texture       = Image[image]
      size          = calculate_size(texture, size)
      position      = calculate_position(position)
      texture_rect  = SDL2::Rect.new position.x, position.y, size.width, size.height

      Hemi::Window.renderer.copy(texture, nil, texture_rect)
    end

    class << self
      attr_reader :images

      def register(image_name)
        @images[image_name] = Hemi::Window.renderer.load_texture "assets/img/#{image_name}.bmp"
      rescue SDL2::Error => _e
        raise ArgumentError, format(ERR__FONT_NOT_FOUND, font_path)
      end

      def [](image_name)
        @images[image_name] || Image.register(image_name)
      end

      def purge!
        @images = {}
      end
    end

  private

    def calculate_size(texture, size = nil)
      size_obj = Size.new(height: nil, width: nil)

      if size.is_a? Array
        size_obj.height = size[0]
        size_obj.width  = size[1]
      elsif size.is_a? Hash
        size_obj.height = size[:height]
        size_obj.width  = size[:width]
      else
        size_obj.height = texture.h
        size_obj.width = texture.w
      end

      size_obj
    end

    def calculate_position(position = nil)
      position_obj = Position.new(x: nil, y: nil)

      if position.nil?
        position_obj.x = 0
        position_obj.y = 0
      elsif position.is_a? Array
        position_obj.x = position[0]
        position_obj.y = position[1]
      elsif position.is_a? Hash
        position_obj.x = position[:x]
        position_obj.y = position[:y]
      else
        raise ArgumentError(ERR__INVALID_POSITION)
      end

      position_obj
    end

  end
end
