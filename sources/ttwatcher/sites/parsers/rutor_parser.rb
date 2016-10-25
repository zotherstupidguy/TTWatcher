# encoding: utf-8

module TTWatcher
module Parsers
  class Rutor < SimpleParser
    private

    def new_pages_list
      return @links if new_pages_list_loaded?
      @links = rutor_structure.xpath('b').first.xpath('a').map do |node|
        node.attribute('href').to_s
      end
    end

    def torrents_unparsed
      rutor_structure.css('tr[@class="gai"], tr[@class="tum"]')
    end

    def rutor_structure
      structure.xpath '//div[@id="index"]'
    end

    # input:  +unparsed_data+ : Nokogiri::Node
    #
    # output: +torrent+ instance
    #
    # fields mapping for  +rutor+
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
    def extract_torrent(unparsed_data)
      hsh = Hash.new

      hsh[:short_link]          = unparsed_data.css('a[@class="downgif"]').attribute('href').to_s
      hsh[:magnet_link]         = unparsed_data.css('a')[1].attribute('href').to_s
      hsh[:url_to_torrent_page] = unparsed_data.css('a')[2].attribute('href').to_s
      hsh[:torrent_name]        = unparsed_data.css('a')[2].text
      hsh[:torrent_size]        = unparsed_data.css('td[@align="right"]').text

      hsh[:tracker_name]         = assigned_site.to_s
      hsh[:direct_download_link] = assigned_site.address(hsh[:short_link])
      hsh[:url_to_torrent_page]  = assigned_site.address(hsh[:url_to_torrent_page] )

      Torrent.new(hsh)
    end
  end # class TTWatcher::Parsers::Rutor
end # module TTWatcher::Parsers
end # module TTWatcher
