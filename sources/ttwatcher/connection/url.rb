# encoding: utf-8

module TTWatcher
module InternetConnection
  #
  # +string+ to url
  #
  class Url
    #
    # present url
    #
    def to_s
      @url
    end

    #
    # input:  +string+ : String /generates +url+ by text from +string+/
    #         +params+ : Hash   /allowed key/value pairs below/
    #
    #         params[:force_scheme] /override default scheme by value in key
    #
    # output: if <ok>    : url instance
    #         if <error> : ???
    #
    def initialize(string, params = {})
      self.class.include Scheme
      @url = string
      set_scheme params[:force_scheme]
      encode_url
    end

    #
    # <ENDPOINT>
    #
    # changes scheme
    #
    #
    # schemes ==> [ 'https', 'http']
    #
    # raise an exception if user need another scheme.
    #
    def scheme_switch
      super
    end

    private

    #
    # Normalization. String to rfc-standard uri
    #
    # note: << DO NOT TRUST IN +URI.decode+ >> (default lib)
    #
    def encode_url
      @url.replace Addressable::URI.parse(@url).normalize.to_s
    end
  end # # class TTWatcher::InternetConnection::Url
end # module TTWatcher::InternetConnection
end # module InternetConnection
