# encoding: utf-8

module TTWatcher
module Parsers
  #
  # Parent class for any Parser classes
  #
  # All you need to see here: abstract method +parse+. it should be somehow
  # implemented in any real parser.
  #
  # note: Do not forget overload next methods: +parse+
  #
  class AbstractParser
    def initialize(site, settings = {})
      @assigned_site = site
      @settings = settings
    end

    #
    # output: if <ok>    : TorrentList object with torrents.
    #                      Can be empty if nothing was found
    #
    #         if <error> : nil
    #
    def parse(page, **params); nil end # +abstract+

    private

    #
    # +assigned_site+ provide sensitive information that parser actually need
    #
    attr_reader :assigned_site
    attr_reader :settings
  end # class TTWatcher::Parsers::AbstractParser

  # ----------------------------------------------------

  #
  # Most sites (like +rutor+) can be parsed with very same algorithm
  #
  # Do not forget overload next methods: +extract_torrents+
  #                                      +goto_next_page+
  #
  class SimpleParser < AbstractParser
    #
    # input: page   [core]     [string]
    #
    # output: if <ok>    : TorrentList object with torrents.
    #                      Can be empty if nothing was found
    #
    #         if <error> : nil
    #
    def parse(page)
      return nil if page.is_a? NilClass

      @page, @structure = page, Nokogiri::HTML(page)
      torrents = TorrentList.new
      until current_page.empty?
        if (extracted = extract_torrents).nil?
          msg = "+extract_torrents+ method in #{self.class} parser return +nil+"
          MessageError.send msg
        else
          torrents << extracted
        end
        goto_next_page
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

    attr_reader :page, :structure

    def current_page
      @page
    end

    #
    # output: if <ok>    : TorrentList instance (can be empty thought)
    #         if <error> : nil
    #
    def extract_torrents; TorrentList.new; end # +abstract+

    #
    # output: if <ok> : changes +@page+ with new content (unparsed html). If
    #                   there no new content it should return empty string.
    #
    def goto_next_page; @page = ''; end # +abstract+
  end # class TTWatcher::Parsers::SimpleParser

  # ----------------------------------------------------

  #
  # This is an +abstract class+ for parsers that needs specific algorithm for parsing
  #
  class SpecialParser < AbstractParser; end
end # module TTWatcher::Parsers
end # module TTWatcher
