# encoding: utf-8

module TTWatcher
module Sites
  class Rutor < TorrentSite # > ex Rutor.org
    include Singleton

    def find_torrent(name)
      super
    end

    private

    def initialize
      super 'rutor.is'
    end

    def default_connection_settings
      { url: { force_scheme: :http } }
    end

    def search_url(name)
      hostname + SEARCH_ROOT % name
    end

    def parser
      @parser ||= Parsers::Rutor.new(self)
    end

    SEARCH_ROOT = '/search/%s'.freeze # note: '%s' used for later interpolation
  end # classTT Watcher::Sites::Rutor
end # module TTWatcher::Sites
end # module TTWatcher
