# encoding: utf-8

module TTWatcher
  class Torrent
    attr_reader :name, :url, :size
    attr_reader :magnet_url, :download_url, :torrent_page

    def initialize(**params)
      @name                = params[:torrent_name]         || 'unknown'
      @url                 = params[:url_to_torrent_page]  || 'unknown'
      @size                = params[:torrent_size]         || 'unknown'
      @magnet_url          = params[:magnet_link]          || 'unknown'
      @download_url        = params[:direct_download_link] || 'unknown'
      @torrent_page        = params[:url_to_torrent_page]  || 'unknown'
    end
  end # class TTWatcher::Torrent

  # ----------------------------------------------------

  #
  # /Delegator/ based on my +ObjectList+ Snippet 2.0.
  #
  class TorrentList
    extend  Forwardable
    include Enumerable

    # Register +push+ method
    #
    # Me want guarantee that TorrentList object is homogeneous.
    # It means only +Torrents+ instances allowed to been stored.
    #
    def push(other)
      case other
      when Torrent
        @torrents.send __method__, other
      when TorrentList
        @torrents += other.to_a
      else
        raise UnexpectedClass.new other
      end
    end

    alias :<< :push

#    def_delegator @torrents, :pop, pop

    def initialize
      @torrents = []
    end

    def each(&block)
      @torrents.each do |obj|
        block.call obj
      end
    end

    class UnexpectedClass < StandardError
      def initialize(arg); super "Expected to get Torrent (or TorrentList) instance, but got #{arg.class} instance"; end end

  end # class TTWatcher::TorrentList
end # module TTWatcher
