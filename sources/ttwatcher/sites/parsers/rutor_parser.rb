# encoding: utf-8

module TTWatcher
module Parsers
  #
  # +Rutor+ parse class
  #
  class Rutor < SimpleParser
    private
    #
    # Output: if <ok>    : TorrentList instance (can be empty thought)
    #         if <error> : nil
    #
    def extract_torrents
      list = TorrentList.new
      torrents_unparsed.each do |unparsed_torrent|
        clear_hsh = parse_torrent(unparsed_torrent)
        list << Torrent.new(clear_hsh)
      end
      list
    end

    #
    # output: if <ok> : changes +@page+ with new content (unparsed html). If
    #                   there no new content just return empty string.
    #
    def goto_next_page
      new_page_url = links_list.pop
      return @page = '' if new_page_url.nil?
      @page = assigned_site.download new_page_url
    end

    #
    # output: if <ok> : returns list of urls that needs to been parsed.
    #
    def links_list
      return @links if @links_list_loaded
      @links_list_loaded = true
      @links ||= structure.xpath('b').first.xpath('a').map do |node|
        node.attribute('href').to_s
      end
    end

    #
    # +Rutor+ placed all data that we need in one place.
    #
    def structure
      super.xpath '//div[@id="index"]'
    end

    def torrents_unparsed
      structure.css('tr[@class="gai"], tr[@class="tum"]')
    end

    # input:  +node+ : Nokogiri::Node
    #
    # output: +hsh+  : Hash (only data  with '++' mark are sent)
    #
    #     ++   hsh[:torrent_name]         ==> ex. "Cats swimming in pool 2016 BDRIP"
    #     --   hsh[:description]          ==> ex. "Hot CATS. Summer 2016"
    #     ++   hsh[:url_to_torrent_page]  ==> ex. "example.torrent.side/12345"
    #     ++   hsh[:tracker_name]         ==> ex. "super-cool tracker"
    #     --   hsh[:author]               ==> ex. 'Bit kitty fun'
    #     --   hsh[:added_date]           ==> ex. '2016-06-15'
    #     --   hsh[:seeders]              ==> ex. 50042
    #     --   hsh[:leeches]              ==> ex. 1
    #     ++   hsh[:torrent_size]         ==> ex. "20000 mb"
    #     ++   hsh[:magnet_link]          ==> ex. "magnet:?xt=urn....................."
    #     ++   hsh[:direct_download_link] ==> ex. "example.torrent.side/12345/download"
    #
    def parse_torrent(node)
      hsh = Hash.new

      hsh[:short_link]          = node.css('a[@class="downgif"]').attribute('href').to_s
      hsh[:magnet_link]         = node.css('a')[1].attribute('href').to_s
      hsh[:url_to_torrent_page] = node.css('a')[2].attribute('href').to_s
      hsh[:torrent_name]        = node.css('a')[2].text
      hsh[:torrent_size]        = node.css('td[@align="right"]').text

      hsh[:tracker_name]         = assigned_site.address
      hsh[:direct_download_link] = assigned_site.address(hsh[:short_link])
      hsh[:url_to_torrent_page]  = assigned_site.address(hsh[:url_to_torrent_page] )

      hsh
    end
  end # class TTWatcher::Parsers::Rutor
end # module TTWatcher::Parsers
end # module TTWatcher
