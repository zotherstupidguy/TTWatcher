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
    def self.included?(url, scheme = nil)
      if scheme
        (url =~ Regexp.new(scheme.to_s << '://')) == 0
      else
        SCHEMES.any? { |p| included?(url, p) }
      end
    end

    def self.add_scheme!(url, scheme)
      if included?(url, scheme)
        url
      else
        url.replace "#{scheme.to_s}://#{url}"
      end
    end

    def scheme
      @scheme
    end

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
        return encode_url if Scheme.included?(@url)
      end
      return encode_url if Scheme.included?(@url, @scheme)

      strip_schemes_from_url!
      Scheme.add_scheme!(@url, @scheme)
    end

    def strip_schemes_from_url!
      SCHEMES.each do |scheme|
        @url.gsub!(scheme.to_s << '://', '') if Scheme.included?(@url, scheme)
      end
    end
  end # module ::InternetConnection::Scheme
end # module TTWatcher::InternetConnection
end # module TTWatcher
