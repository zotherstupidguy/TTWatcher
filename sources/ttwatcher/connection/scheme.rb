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
      current_position = PROTOCOLS.find_index @scheme
      if PROTOCOLS.length > current_position
        @scheme = PROTOCOLS[current_position.next]
      else
        MessageWarn.send "Unknown protocol requested: #{@scheme}!"
      end
      @switched = true
    end

    private

    attr_accessor :first_load

    PROTOCOLS = [:https, :http]
    DEFAULT   = PROTOCOLS.first

    def normalization!
      unless @switched
        return encode_url if protocol_included? :any
      end
      return encode_url if protocol_included? @scheme

      strip_url
      add_actual_protocol
    end

    def set_scheme(protocol = nil)
      @scheme = protocol || DEFAULT
      @switched = false
    end

    def strip_url
      PROTOCOLS.each do |protocol|
        @url.gsub!(protocol.to_s << '://', '') if protocol_included? protocol
      end
    end

    def add_actual_protocol
      @url.replace "#{@scheme.to_s}://#{@url}"
    end

    def protocol_included?(protocol)
      if protocol == :any
        PROTOCOLS.any? { |p| protocol_included? p }
      else
        (@url =~ Regexp.new(protocol.to_s << '://')) == 0
      end
    end
  end # module ::InternetConnection::Scheme
end # module TTWatcher::InternetConnection
end # module TTWatcher
