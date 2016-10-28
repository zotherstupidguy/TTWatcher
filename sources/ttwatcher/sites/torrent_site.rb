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
  class TorrentSite < Site
    #
    # it tries to found specific torrent.
    #
    # input: +name+ [string] torrent name
    #
    # output: if <ok>    : TorrentList instance (can be empty if nothing was found)
    #         if <error> : nil
    #
    # note: minimal length for +name+ is 2 (No reason to search short words
    # like 'aa')
    #
    def find_torrent(name, params = {})
      return nil unless torrent_name_valid? name
      page = download(search_url(name), params)
      parser ? parser.parse(page) : nil
    end

    private

    # ------------ PRIVATE BUT CAN BE OVERLOAD -------------

    #
    # override if you want send specific params (HASH) for parser. See
    # Unionpeer#parser for sample
    #
    def parser(params = {})
      @parser ||=
        begin
          class_name = self.class.name.split('::').last
          parser = TTWatcher::Parsers.const_get(class_name)
          parser.new self, params
        end
    rescue NameError
      notificate_parser_missed
      return nil
    end

    #
    # ------------------ DO NOT OVERLOAD -------------------
    #

    #
    #
    # output: <true>  if name valid (_not nil_ && _not short_)
    #         <false> otherwise
    #
    def torrent_name_valid?(name)
      !(name.nil? || name.length <= 2)
    end

    def notificate_parser_missed
      msg = "Hey! Medved, you forgot to implement parser for #{self.class} site."
      MessageError.send msg
      warn msg
    end
  end # class TTWatcher::Sites::TorrentSite
end # module TTWatcher::Sites
end # module TTWatcher
