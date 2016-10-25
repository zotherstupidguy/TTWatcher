# encoding: utf-8

module TTWatcher
module Sites
  class Rutor < TorrentSite # > ex Rutor.org
    include Singleton
    #
    # it tries to found specific torrent.
    #
    # input: +name+   [string] torrent name
    #
    # output: if <ok>    : TorrentList instance (can be empty if nothing was found)
    #         if <error> : nil
    #
    # note: minimal length for +name+ is 2. <no reason to search short words like 'aa'>
    #
    def find_torrent(name)
      return nil unless torrent_name_valid? name
      page = download(search_url(name))
      @parser.parse page
    end

    private

    def initialize
      super 'rutor.is'
    end

    def default_connection_settings
      { url: { force_scheme: :http } }
    end

    def search_url(name)
      @hostname + SEARCH_ROOT % name
    end

    def parser
      Parsers::Rutor.new self
    end

    SEARCH_ROOT = '/search/%s'.freeze # note: '%s' used for later interpolation
  end # classTT Watcher::Sites::RutorIs
end # module TTWatcher::Sites
end # module TTWatcher
