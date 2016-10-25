# encoding: utf-8

module TTWatcher
module Parsers
  class Megashara < SimpleParser
    private

    #
    # output: if <ok>    : TorrentList instance (can be empty thought)
    #         if <error> : nil
    #
    def extract_torrents
      list = TorrentList.new
      torrents_unparsed.each do |unparsed_torrent|
        torrent = extract_torrent(unparsed_torrent)
        list << torrent
      end
      list
    end

    #
    # output: if <ok> : changes +@page+ with new content (unparsed html). If
    #                   there no new content it should return empty string.
    #
    def goto_next_page
      if new_pages_list.count > 0
        url = new_pages_list.pop
        @page = assigned_site.download url
      else
        @page = ''
      end
    end

    def torrents_unparsed
      structure.css('table[@class="table-wide"]').css('table').css('tr')
    end

    #
    # output: if <ok> : returns list of urls that needs to been parsed.
    #
    def new_pages_list
      return @links if @links_list_loaded
      @links_list_loaded = true

      unparsed_html_data = structure.css('table[@class="pagination-table"]')
                                    .xpath('tr')
                                    .xpath('td')[-2]
      return @links = [] if unparsed_html_data.nil?

      pages_count = unparsed_html_data.css('a').text.to_i - 1
      link_template = unparsed_html_data.css('a').attr('href').to_s

      @links = []
      (1..pages_count).each do |i|
        @links << link_template.gsub(/(\d+)$/, i.to_s)
      end
      @links
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
    #     ++   hsh[:seeders]              ==> ex. 50042
    #     ++   hsh[:leeches]              ==> ex. 1
    #     ++   hsh[:torrent_size]         ==> ex. "20000 mb"
    #     ++   hsh[:magnet_link]          ==> ex. "magnet:?xt=urn....................."
    #     --   hsh[:direct_download_link] ==> ex. "example.torrent.side/12345/download"
    #
    def extract_torrent(unparsed)
      hsh = Hash.new

      hsh[:torrent_name]        = unparsed.css('td')[1].text
      hsh[:magnet_link]         = unparsed.css('td').css('a')[1].attr('href')
      hsh[:url_to_torrent_page] = unparsed.css('td').css('a').attr('href')
      hsh[:torrent_size]        = unparsed.css('td')[3].text
      hsh[:seeders]             = unparsed.css('td')[4].text.to_i
      hsh[:leeches]             = unparsed.css('td')[5].text.to_i

      hsh[:tracker_name] = assigned_site.address

      Torrent.new(hsh)
    end
  end # class TTWatcher::Parsers::Rutracker
end # module TTWatcher::Parsers
end # module TTWatcher
