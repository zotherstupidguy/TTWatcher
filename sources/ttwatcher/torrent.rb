# encoding: utf-8

module TTWatcher
  class Torrent
    #
    # _any_ torrent instance have this attributes:
    #
    attr_reader :name, :description, :url, :size
    attr_reader :author, :added_date, :seeders, :leeches
    attr_reader :magnet_url, :download_url, :torrent_page, :tracker

    #
    #
    #
    attr_reader :type

    #
    #
    #
    def initialize(params = {})
      params_normalization params
      default_initialization params
      extend_instance_by_associated_module params[:extra]
    end

    private

    attr_reader :extra_params

    #
    #
    #
    def params_normalization(params)
      Torrents::Normalization.standardizate! params
    end

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
    def extend_instance_by_associated_module(extra_params = {})
      return if extra_params.nil? || extra_params.empty?

      if (type = extra_params[:type]) && extra_params.delete(:type)
        mod = TTWatcher::Torrents.const_get("#{type.to_s.capitalize + 'Module'}")
        self.extend mod
        @type = type
      end
      @type ||= :unknown
      @extra_params = extra_params.dup

    rescue NameError => exception
      notificate_module_not_found(exception)
      return @extra_params = nil
    end

    def notificate_module_not_found(exception)
      msg = "+Torrent+ extension error. Module not found: <<< #{exception.message.split.last} >>>"
      MessageError.send msg
      warn msg
    end
  end # class TTWatcher::Torrent
end # module TTWatcher
