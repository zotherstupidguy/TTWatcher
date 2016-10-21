# encoding: utf-8

module TTWatcher
module Parsers
  #
  # +Rutor+ parse class
  #
  class Rutor < SimpleParser
    private

    def extract_torrents
      structure.css('tr[@class="gai"]').each do |node|
        hsh =parse_node(node)
        Torrent.new hsh
      end
    end

    #
    # callback: should save in +@page+ new page with torrents. If there no
    #           content for parsing it just returns empty string.
    #
    def goto_next_page
      new_page_url = links_list.pop
      return @page = '' if new_page_url.nil?
      address = assigned_site.address new_page_url
      @page = assigned_site.download address
    end

    #
    # Returns urls list for future parsing.
    #
    def links_list
      return @links if @links_list_loaded
      @links_list_loaded = true
      @links ||= structure.xpath('b').first.xpath('a').map do |node|
        node.attribute('href').to_s
      end
    end

    #
    # +Rutor+ has all data that we need in one place
    #
    def structure
      super.xpath '//div[@id="index"]'
    end

    def parse_node(node)
      hsh = Hash.new
      hsh[:short_link] = node.css('a[@class="downgif"]').attribute('href').to_s
      hsh[:magnet_link] = node.css('a')[1].attribute('href').to_s
      hsh[:url_to_torrent_page] = node.css('a')[2].attribute('href').to_s
      hsh[:torrent_nam] = node.css('a')[2].text
      hsh[:torrent_size] = node.css('td[@align="right"]').text
      hsh[:direct_download_link] = assigned_site.address hsh[:short_link]
      hsh
    end
  end # class TTWatcher::Parsers::Rutor
end # module TTWatcher::Parsers
end # module TTWatcher
