# encoding: utf-8

module TTWatcher
module Parsers
  #
  # base class for Parsers
  #
  # All you need to see here: abstract method +parse+. it should be somehow
  # implemented in any real parser.
  #
  # note: Do not forget overload next methods: +parse+
  #
  # input +site+     [site]
  #       +settings+ [hash]
  #
  # keys mapping for +settings+
  #
  #     settings[:encoding] ==> override parser encoding preferences
  #
  class AbstractParser
    def initialize(site, settings = {})
      @assigned_site = site
      @settings = settings
      @encoding = settings[:encoding] || Encoding::UTF_8.to_s
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
end # module TTWatcher::Parsers
end # module TTWatcher
