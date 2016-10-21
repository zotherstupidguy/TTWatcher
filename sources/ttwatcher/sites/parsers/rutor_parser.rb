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
      structure.css('tr[@class="gai"], tr[@class="tum"]').each do |node|
        hsh_data = parse_node(node)
        list << Torrent.new(hsh_data)
      end
      list
    end

    #
    # output: if <ok> : changes +@page+ with new content (unparsed html). If
    #                   there no new content for parsing it return empty string.
    #
    def goto_next_page
      new_page_url = links_list.pop
      return @page = '' if new_page_url.nil?
      address = assigned_site.address new_page_url
      @page = assigned_site.download address
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

    def parse_node(node)
      hsh = Hash.new

      hsh[:short_link]          = node.css('a[@class="downgif"]').attribute('href').to_s
      hsh[:magnet_link]         = node.css('a')[1].attribute('href').to_s
      hsh[:url_to_torrent_page] = node.css('a')[2].attribute('href').to_s
      hsh[:torrent_name]        = node.css('a')[2].text
      hsh[:torrent_size]        = node.css('td[@align="right"]').text

      hsh[:direct_download_link] = assigned_site.address(hsh[:direct_download_link])
      hsh[:short_link]           = assigned_site.address(hsh[:short_link])
      hsh[:url_to_torrent_page]  = assigned_site.address(hsh[:url_to_torrent_page] )
      hsh
    end
  end # class TTWatcher::Parsers::Rutor
end # module TTWatcher::Parsers
end # module TTWatcher
