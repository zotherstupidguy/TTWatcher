# encoding: utf-8

module TTWatcher
module Sites
  class Rutor < TorrentSite # > ex Rutor.org
    include Singleton

    def initialize
      super 'rutor.is'
    end

    private

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
