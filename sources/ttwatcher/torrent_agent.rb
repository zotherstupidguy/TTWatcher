# encoding: utf-8

module TTWatcher
#
# Search torrents in every place where we can do it.
#
module TorrentAgent
  extend self

  #
  # input: +torrent_name+ [string]    torrent name, minimal length - 3 chars.
  #        +sites+ [array][optional]  list of sites where we looking for torrent.
  #                                   by default it search everywhere
  #
  # output: if <ok>    : TorrentList object with torrents.
  #                      Can be empty if nothing was found
  #
  #         if <error> : nil
  #
  def find(torrent_name, sites = [] )
    list = TorrentList.new
    site_names = sites.empty? ? Sites.list : sites
    site_names.each do |name|
      site = Sites.get_site_by_name name
      new_torrents = site.find_torrent(torrent_name)
      list += new_torrents if new_torrents
    end
    list
  end
end # module TTWatcher::TorrentsAgent
end # module TTWatcher
