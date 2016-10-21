# encoding: utf-8

module TTWatcher
  class Torrent
    def initialize(**params)
      puts params
    end
  end # class TTWatcher::Torrent

  # ----------------------------------------------------

  #
  # /Delegator/ based on my +ObjectList+ Snippet 2.0.
  #
  class TorrentList
    include Enumerable
    extend Forwardable

    #
    # Register '<<', 'methods' for class
    #
    # Customization because i want guarantee that an TorrentList object will
    # be homogeneous. It means only +Torrents+ instances allowed to been stored
    #
    %w(<< push).each do |word|
      define_method(word.to_sym) do |torrent|
        raise StandardError unless torrent === Torrent
        @torrents.send __method__, torrent
      end
    end

    def_delegator @torrents, :pop, :+

    def initialize
      @torrents = []
    end

    def each(&block)
      @torrents.each do |obj|
        block.call obj
      end
    end
  end # class TTWatcher::TorrentList
end # module TTWatcher
