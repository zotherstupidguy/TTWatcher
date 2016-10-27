# encoding: utf-8

module TTWatcher
  class VideoTorrent < Torrent
    #
    #
    #
    class << self
      #
      #
      #
      def build(**params)
        new params
      end

      private

      def sub_types
        { :movie   => MovieTorrent,
          :serial  => SerialTorrent,
          :tv      => TVProgramTorrent,
          :unknown => VideoTorrent }
      end
    end # class << self

    # --------------------INSTANCE ZONE-------------------

    private_class_method :sub_types

    #
    #
    #
    def sub_class_initialization(**params)
    end
  end # class TTWatcher::VideoTorrent

  # ----------------------------------------------------

  class MovieTorrent < VideoTorrent
  end # class TTWatcher::MovieTorrent

  # ----------------------------------------------------

  class SerialTorrent < VideoTorrent
  end # class TTWatcher::SerialTorrent

  # ----------------------------------------------------

  class TVProgramTorrent < VideoTorrent
  end # class TTTWatcher::TVProgramTorrent
end # module TTWatcher
