# encoding: utf-8

module TTWatcher
module Sites
  class Megashara < TorrentSite
    include Singleton

    def find_torrent(name)
      super name, { url: { query_params: { text: name } } }
    end

    private

    def initialize
      super 'megashara.com'
    end

    def default_connection_settings
      { url: { force_scheme: :http } }
    end

    def search_url(name=nil)
      @hostname + SEARCH_ROOT
    end

    def parser
      @parser ||= Parsers::Megashara.new(self)
    end

    SEARCH_ROOT = '/search/%s'.freeze # note: '%s' used for later interpolation
  end # class TTWatcher::Sites::Megashara
end # module TTWatcher::Sites
end # module TTWatcher
