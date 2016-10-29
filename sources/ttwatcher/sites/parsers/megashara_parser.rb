# encoding: utf-8

module TTWatcher
module Parsers
  class Megashara < SimpleParser
    private

    def new_pages_list
      return @links if new_pages_list_loaded?

      unparsed_html_data = structure.css('table[@class="pagination-table"]')
                                    .xpath('tr')
                                    .xpath('td')[-2]
      return @links = [] if unparsed_html_data.nil?

      pages_count   = unparsed_html_data.css('a').text.to_i - 1
      link_template = unparsed_html_data.css('a').attr('href').to_s

      @links = (1..pages_count).map do |i|
        link_template.gsub /(\d+)$/, i.to_s
      end
    end

    def torrents_unparsed
      structure.css('table[@class="table-wide"]').css('table').css('tr')
    end

    # input:  +unparsed_data+ : Nokogiri::Node
    #
    # output: +torrent+ instance
    #
    # fields mapping for +megashara+:
    #
    #     ++   hsh[:name]             ==> ex. "Cats swimming in pool 2016 BDRIP"
    #     --   hsh[:description]      ==> ex. "Hot CATS. Summer 2016"
    #     ++   hsh[:url]              ==> ex. "example.torrent.side/12345"
    #     ++   hsh[:tracker]          ==> ex. "super-cool tracker"
    #     --   hsh[:author]           ==> ex. 'Bit kitty fun'
    #     --   hsh[:added_date]       ==> ex. '2016-06-15'
    #     ++   hsh[:seeders]          ==> ex. 50042
    #     ++   hsh[:leeches]          ==> ex. 1
    #     ++   hsh[:size]             ==> ex. "20000 mb"
    #     ++   hsh[:magnet_url]       ==> ex. "magnet:?xt=urn....................."
    #     --   hsh[:download_url]     ==> ex. "example.torrent.side/12345/download"
    #
    def extract_torrent(unparsed_data)
      hsh = Hash.new

      hsh[:name]        = unparsed_data.css('td')[1].text
      hsh[:magnet_url]  = unparsed_data.css('td').css('a')[1].attr('href')
      hsh[:url]         = unparsed_data.css('td').css('a').attr('href')
      hsh[:size]        = unparsed_data.css('td')[3].text
      hsh[:seeders]     = unparsed_data.css('td')[4].text.to_i
      hsh[:leeches]     = unparsed_data.css('td')[5].text.to_i

      hsh[:tracker] = assigned_site.name

      Torrent.new hsh
    end
  end # class TTWatcher::Parsers::Megashara
end # module TTWatcher::Parsers
end # module TTWatcher
