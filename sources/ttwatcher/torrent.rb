# encoding: utf-8

module TTWatcher
  class Torrent
    attr_reader :name, :description, :url, :size
    attr_reader :author, :added_date, :seeders, :leeches
    attr_reader :magnet_url, :download_url, :torrent_page, :tracker

    #
    # input: +params+ : Hash (allowed key/value pairs below)
    #
    #        params[:torrent_name]         ==> ex. "Cats swimming in pool 2016 BDRIP"
    #        params[:description]          ==> ex. "Hot cats DO IT RIGHT NOW"
    #        params[:url_to_torrent_page]  ==> ex. "example.torrent.side/12345"
    #        params[:tracker_name]         ==> ex. "super-cool tracker"
    #        params[:author]               ==> ex. 'Bit kitty fun'
    #        params[:added_date]           ==> ex. '2016-06-15'
    #        params[:seeders]              ==> ex. 50042
    #        params[:leeches]              ==> ex. 1
    #        params[:torrent_size]         ==> ex. "20000 mb"
    #        params[:magnet_link]          ==> ex. "magnet:?xt=urn....................."
    #        params[:direct_download_link] ==> ex. "example.torrent.side/12345/download"
    #
    # note: any input value from list above _can be_ not defined.
    #
    # output: Torrent object instance
    #
    def initialize(**params)
      @name                = params[:torrent_name]         || nil
      @description         = params[:description]          || nil
      @url                 = params[:url_to_torrent_page]  || nil
      @tracker             = params[:tracker_name]         || nil
      @author              = params[:author]               || nil
      @added_date          = params[:added_date]           || nil
      @seeders             = params[:seeders]              || 0
      @leeches             = params[:leeches]              || 0
      @size                = params[:torrent_size]         || nil
      @magnet_url          = params[:magnet_link]          || nil
      @download_url        = params[:direct_download_link] || nil
    end
  end # class TTWatcher::Torrent

  # ----------------------------------------------------

  #
  # /Delegator/ based on my +ObjectList+ Snippet 2.0.
  #
  class TorrentList
    include Enumerable

    # Register +push+ method
    #
    # Me want guarantee that TorrentList object is homogeneous.
    # It means only +Torrent+ instances allowed to been stored.
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
      self
    end

    alias :<< :push
    alias :+  :push

    def initialize
      @torrents = []
    end

    def each(&block)
      @torrents.each do |obj|
        block.call obj
      end
    end

    #
    # this supposed to been raised when we trying to put into storage not
    # +Torrent+ or +TorrentList+ instance.
    #
    class UnexpectedClass < StandardError
      def initialize(arg); super "Expected to get Torrent (or TorrentList) instance, but got #{arg.class} instance"; end end
  end # class TTWatcher::TorrentList
end # module TTWatcher
