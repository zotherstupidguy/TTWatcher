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
      super 'rutor.is', :rutor
    end

    def default_connection_settings
      { url: { force_scheme: :http } }
    end

    def search_url(name)
      hostname + SEARCH_ROOT % name
    end

    SEARCH_ROOT = '/search/0/0/000/0/%s'.freeze # note: '%s' used for later interpolation
  end # classTT Watcher::Sites::Rutor
end # module TTWatcher::Sites
end # module TTWatcher
