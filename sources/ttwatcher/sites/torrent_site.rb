# encoding: utf-8

module TTWatcher
module Sites
  #
  # Inheritance from this class means that child class provides minimal
  # torrent functional (can search +torrent+ by name)
  #
  # I suppose any additional functional should be provided throw new modules,
  # but not sure. Anyway let the adventure begin from this code. Medved.
  #
  # note:
  #
  # Do not forget overload next methods: +find_torrent+
  #                                      +parser+
  #                                      +default_connection_settings+ [optional]
  #                                      +find_torrent+ [optional]
  class TorrentSite < Site
    #
    # it tries to found specific torrent.
    #
    # input: +name+ [string] torrent name
    #
    # output: if <ok>    : TorrentList instance (can be empty if nothing was found)
    #         if <error> : nil
    #
    # note: minimal length for +name+ is 2. <no reason to search short words like 'aa'>
    #
    def find_torrent(name, params = {})
      return nil unless torrent_name_valid? name
      params ||= {}
      page = download(search_url(name), params)
      parser.parse page
    end

    private

    #
    # override it with specific parser
    #
    def parser; end # +abstract+

    #
    # Do not search torrent if name too short.
    #
    def torrent_name_valid?(name)
      !(name.nil? || name.length <= 2)
    end
  end # class TTWatcher::Sites::TorrentSite
end # module TTWatcher::Sites
end # module TTWatcher
