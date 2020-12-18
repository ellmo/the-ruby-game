module Hemi::Render
  class Sprite < Texture
    ERR__INVALID_POSITION = "Ivalid position.".freeze

    @sprites = {}

    def initialize(name)
      @texture = Hemi::Window.renderer.load_texture("assets/img/#{name}.bmp")
      Sprite.register(name, self)
    rescue SDL2::Error => _e
      raise ArgumentError, format(ERR__FONT_NOT_FOUND, font_path)
    end

    def render(position: nil, size: nil)
      size         = calculate_size(size)
      position     = calculate_position(position)
      texture_rect = SDL2::Rect.new(*position, *size)

      Hemi::Window.renderer.copy(texture, nil, texture_rect)
    end

    class << self
      attr_reader :sprites

      def bucket
        :sprites
      end
    end
  end
end