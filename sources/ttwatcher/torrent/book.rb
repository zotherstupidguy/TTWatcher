# encoding: utf-8

module TTWatcher
  #
  #
  #
  class BookTorrent < Torrent
    class << self
      #
      #
      #
      def build(**params)
        new params
      end
    end # class << self

    # --------------------INSTANCE ZONE-------------------

    #
    #
    #
    def sub_class_initialization(**params)
    end
  end # class TTWatcher::BookTorrent
end # module TTWatcher
