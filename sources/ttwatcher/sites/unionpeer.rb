# encoding: utf-8

module TTWatcher
module Sites
  class Unionpeer < TorrentSite
    include Singleton

    def find_torrent(name)
      super name, { url: { query_params: { 'nm' => name } } }
    end

    private

    def initialize
      super 'unionpeer.org'
    end

    def default_connection_settings
      { url: { force_scheme: :http, encoding: ENCODING } }
    end

    def search_url(name=nil)
      hostname + SEARCH_ROOT
    end

    def parser
      @parser ||= Parsers::Unionpeer.new(self, encoding: ENCODING)
    end

    ENCODING    = Encoding::Windows_1251.to_s.freeze
    SEARCH_ROOT = '/tracker.php'.freeze
  end # class TTWatcher::Sites::Unionpeer
end # module TTWatcher::Sites
end # module TTWatcher
