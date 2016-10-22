# encoding: utf-8

module TTWatcher
module InternetConnection
  #
  # +string+ to +url+ normalization
  #
  class Url
    #
    # presents url
    #
    def to_s
      @url
    end

    def initialize(string)
      self.class.include Scheme
      @url = string
      config_scheme
      encode_url
    end

    #
    # switch scheme for url instance
    #
     def scheme_switch
       super
       normalization!
     end

    private

    def config_scheme
      set_scheme
      normalization!
    end

    def encode_url
      @url.replace Addressable::URI.parse(@url).normalize.to_s
    end
  end # # class TTWatcher::InternetConnection::Url
end # module TTWatcher::InternetConnection
end # module InternetConnection
