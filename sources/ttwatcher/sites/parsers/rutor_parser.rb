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
    # fields mapping for +rutor+
    #
    #     ++   hsh[:name]             ==> ex. "Cats swimming in pool 2016 BDRIP"
    #     --   hsh[:description]      ==> ex. "Hot CATS. Summer 2016"
    #     ++   hsh[:url]              ==> ex. "example.torrent.side/12345"
    #     ++   hsh[:tracker]          ==> ex. "super-cool tracker"
    #     --   hsh[:author]           ==> ex. 'Bit kitty fun'
    #     ++   hsh[:added_date]       ==> ex. '2016-06-15'
    #     ++   hsh[:seeders]          ==> ex. 50042
    #     ++   hsh[:leeches]          ==> ex. 1
    #     ++   hsh[:size]             ==> ex. "20000 mb"
    #     ++   hsh[:magnet_url]       ==> ex. "magnet:?xt=urn....................."
    #     ++   hsh[:download_url]     ==> ex. "example.torrent.side/12345/download"
    #
    def extract_torrent(unparsed_data)
      hsh = Hash.new

      hsh[:short_link]  = unparsed_data.css('a[@class="downgif"]').attribute('href').to_s
      hsh[:magnet_url]  = unparsed_data.css('a')[1].attribute('href').to_s
      hsh[:url]         = unparsed_data.css('a')[2].attribute('href').to_s
      hsh[:name]        = unparsed_data.css('a')[2].text
      hsh[:added_date]  = unparsed_data.css('td')[0].text
      hsh[:seeders]     = unparsed_data.css('td[@align="center"]').css('span')[0].text
      hsh[:leeches]     = unparsed_data.css('td[@align="center"]').css('span')[1].text

      if (tmp_size = unparsed_data.css('td[@align="right"]')[1])
        hsh[:size] = tmp_size.text
      end

      hsh[:tracker]      = assigned_site.name
      hsh[:download_url] = assigned_site.address(hsh[:short_link])
      hsh[:url]          = assigned_site.address(hsh[:url] )

      Torrent.new hsh
    end
  end # class TTWatcher::Parsers::Rutor
end # module TTWatcher::Parsers
end # module TTWatcher
