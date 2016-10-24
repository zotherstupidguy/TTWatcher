# encoding: utf-8

module TTWatcher
module Sites
  #
  # Inheritance from this class means that child class provides minimal
  # torrent functional (can search +torrents+ by name)
  #
  # I suppose any additional functional should be provided throw new modules,
  # but i am not sure. Anyway let the adventure begin from this code. Medved.
  #
  # note:
  #
  # Do not forget overload next methods: +parser+
  #                                      +search_url+
  #
  class TorrentSite < Site
    #
    # <<USER ENDPOINT>>
    #
    # it tries to found specific torrent.
    #
    # input: +name+   [string] torrent name
    #
    # output: if <ok>    : TorrentList instance (can be empty if nothing was found)
    #         if <error> : nil
    #
    # note: minimal length for +name+ is 2. <no reason to search short words like 'aa'>
    #
    def find_torrent(name)
      return nil if name.nil? || name.length <= 2
      page = download(search_url(name))
      @parser.parse page
    end

    private

    #
    # override with specific parser
    #
    def parser; end # +abstract+

    #
    # override with specific search url
    #
    def search_url(name) end # +abstract+
  end # class TTWatcher::Sites::TorrentSite
end # module TTWatcher::Sites
end # module TTWatcher
