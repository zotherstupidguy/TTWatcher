# encoding: utf-8

module TTWatcher
module Parsers
  #
  # Most sites (like +rutor+) can be parsed with very same algorithm
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
      @page = page
      torrents = TorrentList.new
      until page.empty?
        if (extracted = extract_torrents).nil?
          msg = "+extract_torrents+ method in #{self.class} parser return +nil+"
          MessageError.send msg
        else
          torrents << extracted
        end
        break if goto_next_page.empty?
      end
      torrents
    rescue Exception => e # IT IS SO BAD. DO NOT /rescue Exception/
                          # <<important>> i do understand what i do.
      msg = "Unknown exception has been raised: '#{e.message}' for '#{self.class}' parser."
      MessageError.send msg
      warn msg, '- -' * 20, e.backtrace.join("\n")
      return nil
    end

    private

    attr_accessor :page, :structure, :encoding

    #
    # output: list of links that should be scanned for torrents search
    #
    def new_pages_list; end # +abstract+

    #
    # output: Nokogiri::Node with all torrents placed on current +@page+
    #
    def torrents_unparsed; end # +abstract+

    #
    # input:  +unparsed+ : Nokogiri::Node
    # output: +torrent+ instance
    #
    def extract_torrent(unparsed); end # +abstract+

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

    def page
      @page.encoding == encoding ? @page : @page.force_encoding(encoding)
    end
  end # class TTWatcher::Parsers::SimpleParser
end # module TTWatcher::Parsers
end # module TTWatcher
