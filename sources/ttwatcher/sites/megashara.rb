# encoding: utf-8

module TTWatcher
module Sites

  class Megashara < TorrentSite
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
      params = { url: { query_params: { text: name } } }

      page = download(search_url, params)
      @parser.parse page
    end

    def initialize
      super 'megashara.com'
    end

    private

    def default_connection_settings
      { url: { force_scheme: :http } }
    end


    def search_url
      @hostname + SEARCH_ROOT
    end

    def parser
      Parsers::Megashara.new self
    end

    SEARCH_ROOT = '/search/%s'.freeze # note: '%s' used for later interpolation
  end # class TTWatcher::Sites::Megashara
end # module TTWatcher::Sites
end # module TTWatcher
