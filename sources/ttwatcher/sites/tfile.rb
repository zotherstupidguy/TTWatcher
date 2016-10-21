# encoding: utf-8

module TTWatcher
module Sites
  class TFile < TorrentSite
    include Singleton

    def initialize
      super 'tfile.co'
    end

    private

    def parser
      Parsers::TFile.new self
    end

  end # classTT Watcher::TFile
end # module TTWatcher::Sites::TFile
end # module TTWatcher
