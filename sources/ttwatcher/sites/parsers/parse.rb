# encoding: utf-8

module TTWatcher
module Parsers
  #
  # Parent class for any Parser classes
  #
  # All you need to see here: it is just an abstract method +parse+ that
  # should be somehow implemented in real parsers
  #
  class AbstractParser
    def initialize(site)
      @assigned_site = site
    end

    #
    # output: TorrentList object with torrents or
    #         +nil+ if any error happiness
    #
    def parse(page); nil end # +abstract+

    private

    attr_reader :assigned_site
  end # class TTWatcher::Parsers::AbstractParser

  # ----------------------------------------------------

  #
  # Most sites (like +rutor+) can be parsed with very same algorithm
  #
  class SimpleParser < AbstractParser
    def parse(page)
      return nil if page.is_a? NilClass
      @page, @structure = page, Nokogiri::HTML(page)
      torrents = TorrentList.new
      until current_page.empty?
        torrents = extract_torrents
        goto_next_page
      end
      torrents
    end

    private

    attr_reader :page, :structure

    def extract_torrents; ''; end       # +abstract+
    def goto_next_page; @page = ''; end # +abstract+
    def current_page; @page; end        # +abstract+
  end # class TTWatcher::Parsers::SimpleParser

  # ----------------------------------------------------

  #
  # This is an +abstract class+ for parsers that needs specific parse algorithms
  #
  class SpecialParser < AbstractParser; end
end # module TTWatcher::Parsers
end # module TTWatcher
