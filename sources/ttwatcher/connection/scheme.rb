# encoding: utf-8

module TTWatcher
module InternetConnection

  #
  # <<Breaking news>> Some cites still using http.
  #
  # This module designed to switch&normalizate scheme for +url+ instance, if default (https)
  # scheme not supported.
  #
  module Scheme
    def scheme_switch
      @allowed_schemes -= [ @scheme ]
      if @allowed_schemes.length > 0
        @scheme = @allowed_schemes.first
      else
        MessageWarn.send "Unknown scheme requested: #{@scheme}!"
      end
      @switched = true

      normalization!
    end

    private

    attr_accessor :first_load

    SCHEMES = [ :https, :http ]
    DEFAULT   = SCHEMES.first

    def set_scheme(scheme = nil)
      @scheme = scheme || DEFAULT
      @allowed_schemes = SCHEMES.dup
      @switched = false

      normalization!
    end

    def normalization!
      unless @switched
        return encode_url if scheme_included? :any
      end
      return encode_url if scheme_included? @scheme

      strip_schemes_from_url!
      add_actual_scheme!
    end

    def strip_schemes_from_url!
      SCHEMES.each do |protocol|
        @url.gsub!(protocol.to_s << '://', '') if scheme_included? protocol
      end
    end

    def add_actual_scheme!
      @url.replace "#{@scheme.to_s}://#{@url}"
    end

    def scheme_included?(protocol)
      if protocol == :any
        SCHEMES.any? { |p| scheme_included? p }
      else
        (@url =~ Regexp.new(protocol.to_s << '://')) == 0
      end
    end
  end # module ::InternetConnection::Scheme
end # module TTWatcher::InternetConnection
end # module TTWatcher
