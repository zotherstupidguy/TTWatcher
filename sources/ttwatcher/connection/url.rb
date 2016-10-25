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
    #         params[:force_scheme] /overrides default scheme/
    #         params[:query_params] /url query/
    #         params[:encoding]     /encoding. by default: utf-8/
    #
    # output: if <ok>    : url instance
    #         if <error> : ???
    #
    def initialize(string, params = {})
      params ||= {}
      self.class.include Scheme

      @url      = string
      @query    = params[:query_params] || {}
      @encoding = params[:encoding]     || 'utf-8'

      set_scheme params[:force_scheme]
      encode_url
    end

    #
    # <ENDPOINT>
    #
    # changes scheme
    #
    # schemes ==> [ 'https', 'http']
    #
    # raise an exception if user need another scheme.
    #
    def scheme_switch
      super
    end

    private

    attr_reader :encoding

    #
    # return +query+ with correct encoding
    #
    def query_normalization
      uri =  Addressable::URI.parse(@url)
      tmp_q = (uri.query_values || {}).merge(@query)

      return tmp_q if tmp_q.empty? && tmp_q.values.all? { |v| v.encode == @encoding }
      tmp_q.each_key { |k| tmp_q[k].encode! @encoding }
      tmp_q
    end

    #
    # Normalization. String to rfc-standard uri
    #
    # note: << DO NOT TRUST IN +URI.decode+ >> (default lib)
    #
    def encode_url
      uri =  Addressable::URI.parse(@url)
      uri.query_values = query_normalization
      @url.replace uri.normalize.to_s.force_encoding(@encoding)
    end
  end # # class TTWatcher::InternetConnection::Url
end # module TTWatcher::InternetConnection
end # module InternetConnection
