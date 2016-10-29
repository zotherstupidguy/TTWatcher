# encoding: utf-8

module TTWatcher
  module Torrents

    # #
    # # output: hash with keys associated with torrent class. For any key that
    # #         not in list below it returns UnknownTorrent class.
    # #
    # # note: @TORRENT_PRIMARY_TYPES_MAPPING used for caching.
    # #
    # def torrent_primary_types_mapping
    #   @TORRENT_PRIMARY_TYPES_MAPPING ||=
    #     begin
    #       tmp = Hash.new { |hash, key| hash[key] = Unknown }
    #       tmp.merge({ :video => Video,
    #                   :sound => Sound,
    #                   :soft => Soft,
    #                   :game => Game,
    #                   :book => Book,
    #                   :other => Other,
    #                   :unknown => Unknown })
    #     end
    # end

    #
    #
    #
    def self.determinate_torrent_type!(**data)
    end
  end # module TTWatcher::Torrent
end # module TTWatcher
