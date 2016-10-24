# encoding: utf-8

module TTWatcher
#
# Search torrents in every place where we can do it.
#
module TorrentAgent
  extend self

  #
  # input: torrent_name [string] torrent name
  #        sites [array][optional] list of sites where we looking for torrent.
  #                                by default we are looking everywhere where
  #                                we can (ex. sites = [ :site1, :site2 ])
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
      list += site.find_torrent(torrent_name)
    end
    list
  end
end # module TTWatcher::TorrentsAgent
end # module TTWatcher
