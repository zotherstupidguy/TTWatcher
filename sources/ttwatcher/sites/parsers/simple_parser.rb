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
    # Do not forget overload next methods: +new_pages_list+
    #                                      +torrents_unparsed+
    #                                      +extract_torrent+
    def parse(page)
      return nil if page.is_a? NilClass

      @page, torrents = page, TorrentList.new
      begin
        if (extracted = extract_torrents).nil?
          msg = "+extract_torrents+ method in #{self.class} parser return +nil+"
          MessageError.send msg
        else
          torrents << extracted
        end
      end until goto_next_page.empty?
      return torrents
    rescue Exception => exception # <<IMPORTANT! this will catch __any__ exception. >>
      notificate_about_parser_crash! exception
      return nil
    end

    private

    attr_accessor :page, :structure, :encoding

    # -------------- PRIVATE CAN BE OVERLOAD ---------------

    #
    # output: list of links that should be scanned for full torrents extract
    #
    def new_pages_list; end # +abstract+

    #
    # output: homogeneous array of Nokogiri::Nodes. Each element from array
    # should have all available information about _1_ torrent.
    #
    def torrents_unparsed; end # +abstract+

    #
    # input:  +unparsed+ : Nokogiri::Node
    # output: +torrent+ instance
    #
    def extract_torrent(unparsed); end # +abstract+

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
