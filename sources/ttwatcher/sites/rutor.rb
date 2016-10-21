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
      @root + SEARCH_ROOT % name
    end

    def parser
      Parsers::Rutor.new self
    end

    GLOBAL_ROOT = '/browse/0/0/0/0/%s'.freeze # note: '%s' used for later interpolation
    SEARCH_ROOT = '/search/%s'.freeze
  end # classTT Watcher::Sites::RutorIs
end # module TTWatcher::Sites
end # module TTWatcher
