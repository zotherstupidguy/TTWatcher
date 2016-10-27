# encoding: utf-8

module TTWatcher
  #
  #
  #
  class UnknownTorrent < Torrent
    #
    #
    #
    def self.build(**params)
      new params
    end

    # --------------------INSTANCE ZONE-------------------

    def sub_class_initialization(**params); end
  end # class TTWatcher::UnknownTorrent
end # module TTWatcher
