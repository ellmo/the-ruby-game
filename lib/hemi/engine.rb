require "singleton"
require "sdl2"

require_relative "loader"

module Hemi
  module Engine
    @debug = false
    @stop  = false

    def initialize
      sdl_init
      super
    end

    attr_reader :window

    def sdl_init
      SDL2.init(SDL2::INIT_EVERYTHING)
    end

    class << self
      attr_reader :debug, :stop

      def prepended(klass)
        klass.include Singleton

        Loader.load_tree "helpers"
        Loader.load_tree "render"
        Loader.load_tree "input"
        Loader.load_tree "event"
      end

      def debug_on!
        @debug = true
      end

      def debug_off!
        @debug = false
      end

      def stop!
        @stop = true
      end
    end

    def run
      super if defined?(super)
      init_window
      start_loop
    end

  private

    def init_window
      @window = Hemi::Render::Window.instance
    end

    def start_loop
      Hemi::Event::LoopMachine.instance.call
    end
  end
end
