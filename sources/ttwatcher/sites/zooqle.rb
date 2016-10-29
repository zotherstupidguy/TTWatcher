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
      super 'zooqle.com', :zooqle
    end

    def default_connection_settings; {} end

    def search_url(name=nil)
      hostname + SEARCH_ROOT
    end

    SEARCH_ROOT = '/search'.freeze
  end # class TTWatcher::Sites::Zooqle
end # module TTWatcher::Sites
end # module TTWatcher
