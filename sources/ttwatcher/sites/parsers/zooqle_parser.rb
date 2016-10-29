# encoding: utf-8

module TTWatcher
module Parsers
  class Zooqle < SimpleParser
    private

    def new_pages_list
      return @links if new_pages_list_loaded?

      tmp = structure.css('ul[@class="pagination smaller pull-right margin-top-20"]')
                     .css('li')
      return @links = [] if tmp.nil? || tmp.empty?

      url_part = tmp.css('a').attr('href').to_s.gsub(/pg=\d*/,'pg=+NUMBER+')
      mm = tmp.slice(0..-2).map { |node| node.css('a').text.to_i}.minmax

      @links = (mm.first..mm.last).map do |page_number|
        'search' + url_part.gsub(/\+NUMBER\+/, page_number.to_s)
      end.slice!(2..-1) || []
    end

    def torrents_unparsed
      structure.css('table[@class="table table-condensed table-torrents vmiddle"]')
               .css('tr').drop(1)
    end

    # input:  +unparsed_data+ : Nokogiri::Node
    #
    # output: +torrent+ instance
    #
    # fields mapping for +zooqle+:
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
    #     ++   hsh[:download_url]     ==> ex. "example.torrent.side/12345/download"
    #
    def extract_torrent(unparsed_data)
      hsh = Hash.new

      hsh[:name] = unparsed_data.css('td')[1].text

      tmp_td1   = unparsed_data.css('td')[1].css('a').attr('href').to_s
      hsh[:url] = assigned_site.address(tmp_td1)

      tmp_td2 = unparsed_data.css('td')[2].css('li')
      hsh[:magnet_url] = tmp_td2[0].css('a').attr('href')
      if tmp_td2[1]
        tmp = tmp_td2[1].css('a').attr('href').to_s
        hsh[:download_url] = assigned_site.address(tmp)
      end

      hsh[:size] = unparsed_data.css('td')[3].text

      tmp_td5 = unparsed_data.css('td')[5]
                             .css('div[@class="progress prog trans90"]')
                             .css('div')
      if tmp_td5[1]
        hsh[:seeders] = tmp_td5[1].text.to_i
        hsh[:leeches] = tmp_td5[2].text.to_i
      end

      hsh[:tracker] = assigned_site.name

      Torrent.new hsh
    end
  end # class TTWatcher::Parsers::Zooqle
end # module TTWatcher::Parsers
end # module TTWatcher
