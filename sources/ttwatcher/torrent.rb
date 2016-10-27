# encoding: utf-8

module TTWatcher
  class Torrent
    class << self
      #
      #
      #
      def build(**data)
        normalization! data
        determinate_torrent_type! data
        build_torrent data
      end

      private

      #
      #
      #
      def normalization!(**params)
        Normalization.standardizate! params
      end

      #
      #
      #
      def determinate_torrent_type!(**params)
        Torrents.determinate_torrent_type! params
      end

      #
      #
      #
      def build_torrent(**hsh)
        (type = hsh[:torrent_type]) && hsh.delete(:torrent_type)

        torrent = if torrent_primary_types_mapping[type]
                    torrent_primary_types_mapping[type]
                  else
                    torrent_primary_types_mapping[:unknown]
                  end
        torrent.build hsh
      end

      #
      #
      #
      def torrent_primary_types_mapping
       { :video   => VideoTorrent,
         :sound   => SoundTorrent,
         :soft    => SoftTorrent,
         :game    => GameTorrent,
         :book    => BookTorrent,
         :other   => OtherTorrent,
         :unknown => UnknownTorrent }
      end
    end # class < self

    # --------------------INSTANCE ZONE-------------------

    #
    #
    #
    private_class_method :new
    private_class_method :normalization!, :determinate_torrent_type!,
                         :build_torrent, :torrent_primary_types_mapping
    #
    #
    #
    attr_reader :name, :description, :url, :size
    attr_reader :author, :added_date, :seeders, :leeches
    attr_reader :magnet_url, :download_url, :torrent_page, :tracker

    #
    #
    #
    def initialize(**params)
      default_initialization params
      sub_class_initialization params
    end

    private

    #
    # input: +params+ : Hash (allowed key/value pairs below)
    #
    #        params[:name]            ==> ex. "Cats swimming in pool 2016 BDRIP"
    #        params[:description]     ==> ex. "Hot cats DO IT RIGHT NOW"
    #        params[:url]             ==> ex. "example.torrent.side/12345"
    #        params[:tracker]         ==> ex. "super-cool tracker"
    #        params[:author]          ==> ex. 'Bit kitty fun'
    #        params[:added_date]      ==> ex. '2016-06-15'
    #        params[:seeders]         ==> ex. 50042
    #        params[:leeches]         ==> ex. 1
    #        params[:size]            ==> ex. "20000 mb"
    #        params[:magnet_url]      ==> ex. "magnet:?xt=urn....................."
    #        params[:download_url]    ==> ex. "example.torrent.side/12345/download"
    #
    # note: any input value from list above _can be_ not defined.
    #
    # output: Torrent object instance
    #
    def default_initialization(**params)
      %w(name description url tracker author added_date seeders leeches size
         magnet_url download_url).each do |word|

        instance_variable_set("@#{word.to_sym}", params[word.to_sym])
        params.delete word.to_sym
      end
    end

    #
    #
    #
    def sub_class_initialization(**params); end # +abstract+

    #
    #
    #
    class AbstractClassError < StandardError
      def initialize; super "You cannot create Torrent instance directly!" end; end
  end # class TTWatcher::Torrent
end # module TTWatcher
