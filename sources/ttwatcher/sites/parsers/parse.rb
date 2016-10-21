# encoding: utf-8

module TTWatcher
module Parsers
  #
  # Parent class for any Parser classes
  #
  # All you need to see here: it is  abstract method +parse+. it should be
  # somehow implemented in any real parser.
  #
  class AbstractParser
    def initialize(site)
      @assigned_site = site
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
  end # class TTWatcher::Parsers::AbstractParser

  # ----------------------------------------------------

  #
  # Most sites (like +rutor+) can be parsed with very same algorithm
  #
  class SimpleParser < AbstractParser
    #
    # input: page   [core]     [string]
    #        params [optional] [hash]
    #
    # output: if <ok>    : TorrentList object with torrents.
    #                      Can be empty if nothing was found
    #
    #         if <error> : nil
    #
    def parse(page, **params)
      return nil if page.is_a? NilClass
      @page, @structure = page, Nokogiri::HTML(page)
      torrents = TorrentList.new
      until current_page.empty?
        if (extracted = extract_torrents).nil?
           MessageError.send "extract method for #{self.class} parser return +nil+"
        else
          torrents << extracted
        end
        goto_next_page
      end
      torrents
    rescue Exception => e # /bla-bla-bla/ IT IS SO BAD /bla-bla-bla/
                          # <<important>> i do understand what i do.
      msg = "Unknown exception during parse procedure has been raised: #{e.message}"
      MessageError.send msg
      warn msg
      return nil
    end

    private

    attr_reader :page, :structure

    def extract_torrents; ''; end       # +abstract+
    def goto_next_page; @page = ''; end # +abstract+
    def current_page; @page; end        # +abstract+
  end # class TTWatcher::Parsers::SimpleParser

  # ----------------------------------------------------

  #
  # This is an +abstract class+ for parsers that needs specific algorithm for parsing
  #
  class SpecialParser < AbstractParser; end
end # module TTWatcher::Parsers
end # module TTWatcher
