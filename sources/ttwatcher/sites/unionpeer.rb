# encoding: utf-8

module TTWatcher
module Sites

  class Unionpeer < TorrentSite
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
      params = { url: { query_params: { 'nm' => name } } }
      page = download(search_url, params)
      parser.parse page
    end

    private

    def initialize
      super 'unionpeer.org'
    end

    def default_connection_settings
      { url: { force_scheme: :http, encoding: ENCODING } }
    end

    def search_url
      hostname + SEARCH_ROOT
    end

    def parser
      @parser ||= Parsers::Unionpeer.new(self, encoding: ENCODING)
    end

    ENCODING    = Encoding::Windows_1251.to_s
    SEARCH_ROOT = '/tracker.php'
  end # class TTWatcher::Sites::Rutracker
end # module TTWatcher::Sites
end # module TTWatcher
