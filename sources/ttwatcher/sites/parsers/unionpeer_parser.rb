# encoding: utf-8

module TTWatcher
module Parsers
  class Unionpeer < SimpleParser
    private

    def new_pages_list
      return @links if new_pages_list_loaded?

      @links = structure.css('p[@class="small"]').css('a').map do |node|
        node.attr('href')
      end.slice!(1..-2) || []
    end

    def torrents_unparsed
      structure.css('tr[class="tCenter hl-tr "]')
    end

    # input:  +unparsed_data+ : Nokogiri::Node
    #
    # output: +torrent+ instance
    #
    # fields mapping for +unionpeer+:
    #
    #     ++   hsh[:name]             ==> ex. "Cats swimming in pool 2016 BDRIP"
    #     --   hsh[:description]      ==> ex. "Hot CATS. Summer 2016"
    #     ++   hsh[:url]              ==> ex. "example.torrent.side/12345"
    #     ++   hsh[:tracker]          ==> ex. "super-cool tracker"
    #     ++   hsh[:author]           ==> ex. 'Bit kitty fun'
    #     ++   hsh[:added_date]       ==> ex. '2016-06-15'
    #     ++   hsh[:seeders]          ==> ex. 50042
    #     ++   hsh[:leeches]          ==> ex. 1
    #     ++   hsh[:size]             ==> ex. "20000 mb"
    #     --   hsh[:magnet_url]       ==> ex. "magnet:?xt=urn....................."
    #     ++   hsh[:download_url]     ==> ex. "example.torrent.side/12345/download"
    #
    def extract_torrent(unparsed_data)
      hsh = Hash.new

      hsh[:name]       = unparsed_data.css('a[@class="genmed2 tLink"]').text
      hsh[:author]     = unparsed_data.css('td[@class=row1]')[2].text
      hsh[:size]       = unparsed_data.css('a[@class="small tr-dl"]').text
      hsh[:added_date] = unparsed_data.css('td[@class="row4 small nowrap"]').css('p').text
      hsh[:seeders]    = unparsed_data.css('td[@class="row4 seedmed bold"]').text.to_i
      hsh[:leeches]    = unparsed_data.css('td[@class="row4 leechmed"]').text.to_i

      url = unparsed_data.css('a[@class="genmed2 tLink"]').attr('href').to_s
      hsh[:url] = assigned_site.address(url)

      url = unparsed_data.css('a[@class="small tr-dl"]').attr('href').to_s
      hsh[:download_url] = assigned_site.address(url)

      hsh[:tracker] = assigned_site.name

      Torrent.new hsh
    end
  end # class TTWatcher::Parsers::Unionpeer
end # module TTWatcher::Parsers
end # module TTWatcher
