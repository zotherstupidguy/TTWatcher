# encoding: utf-8

module TTWatcher
module Sites
  class TorrentSite < Site

    # tries to extract all sites from site
    def find_all_torrents; end

    # tries to found specific torrent
    def find_torrent(name)
      page = download(search_url(name))
      @parser.parse page
    end

    # tries to found sites by specific date
    def find_torrents_by_date; end

    private

    def search_url(name) end # +abstract+

    attr_reader :parser

    TransactionSize = 200 # Some queries can be so big. this is

  end # class TTWatcher::Sites::TorrentSite
end # module TTWatcher::Sites
end # module TTWatcher
