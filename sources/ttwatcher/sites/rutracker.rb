# encoding: utf-8

module TTWatcher
module Sites

  class Rutracker < TorrentSite
    include Singleton

    def initialize
      super 'rutracker.org'
    end

    private

    def parser
      Parsers::Rutracker.new self
    end

  end # class TTWatcher::Sites::Rutracker
end # module TTWatcher::Sites
end # module TTWatcher
