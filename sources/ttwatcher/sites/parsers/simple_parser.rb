# encoding: utf-8

module TTWatcher
module Parsers
  #
  # Most sites (like +rutor+) can be parsed with very simple algorithm
  #
  class SimpleParser < AbstractParser
    #
    # input: page [string]
    #
    # output: if <ok>    : TorrentList object with torrents.
    #                      Can be empty if nothing was found
    #
    #         if <error> : nil
    #
    def parse(page)
      return nil if page.is_a? NilClass

      @page, torrents = page, TorrentList.new
      loop do
        torrents << extract_torrents_from_page
        break if next_page.empty?
      end
      torrents
    rescue Exception => exception # <<IMPORTANT! this will catch __any__ exception. >>
      notificate_about_parser_crash! exception
      return nil
    end

    private

    attr_accessor :page, :structure, :encoding

    # ------------ PRIVATE BUT CAN BE OVERLOAD -------------

    #
    # output: list of links that should be scanned for full torrents extract
    #
    abstract_method :new_pages_list

    #
    # output: homogeneous array of Nokogiri::Nodes. Each element from array
    # should have all available information about _1_ torrent.
    #
    abstract_method :torrents_unparsed

    #
    # input:  +unparsed_data+ : Nokogiri::Node
    # output: +torrent+ instance
    #
    abstract_method 'unparsed_data', :extract_torrent

    #
    # note: designed to use with +new_pages_list+ method.
    #
    def new_pages_list_loaded?
      if @new_pages_list_loaded
        true
      else
        @new_pages_list_loaded  = true
        false
      end
    end

    def structure
      Nokogiri::HTML(page, nil, encoding)
    end

    #
    # ------------------ DO NOT OVERLOAD -------------------
    #

    #
    # output: if <ok>    : TorrentList instance (can be empty thought)
    #
    def extract_torrents_from_page
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
    def next_page
      if new_pages_list.count > 0
        url = new_pages_list.pop
        @page = assigned_site.download url
      else
        @page = ''
      end
    end

    def page
      @page.encoding == encoding ? @page : @page.force_encoding(encoding)
    end

    def notificate_about_parser_crash!(exception)
      msg = "Parser #{self.class} crashed with error: #{exception.inspect}"
      MessageError.send msg
      warn msg
    end
  end # class TTWatcher::Parsers::SimpleParser
end # module TTWatcher::Parsers
end # module TTWatcher
