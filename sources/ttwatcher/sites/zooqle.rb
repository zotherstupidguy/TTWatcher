# encoding: utf-8

module TTWatcher
module Sites
  class Zooqle < TorrentSite
    include Singleton

    def find_torrent(name)
      super name, { url: { query_params: { 'q' => name } } }
    end

    private

    def initialize
      super 'zooqle.com'
    end

    def search_url(name=nil)
      hostname + SEARCH_ROOT
    end

    def parser
      @parser ||= Parsers::Zooqle.new(self)
    end

    SEARCH_ROOT = '/search'.freeze
  end # class TTWatcher::Sites::Zooqle
end # module TTWatcher::Sites
end # module TTWatcher