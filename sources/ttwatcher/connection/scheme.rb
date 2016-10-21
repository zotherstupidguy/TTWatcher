# encoding: utf-8

module TTWatcher
module InternetConnection
  #
  # <<Breaking news>> Some cites still using http.
  #
  # This module designed to switch scheme for selected url, if default (https)
  # scheme not supported.
  #
  class Scheme
    def initialize(protocol = nil)
      @scheme = protocol || DEFAULT
      @switched = false
    end
    #
    # <Warn> +normalization!+ method mutates +url+ param.
    #
    def normalization!(url)
      unless @switched
        return url if protocol_included?(url, :any)
      end

      return url if protocol_included?(url, @scheme)

      strip_url url
      add_actual_protocol url
    end

    def switch
      current_position = PROTOCOLS.find_index @scheme
      if PROTOCOLS.length > current_position
        @scheme = PROTOCOLS[current_position.next]
      else
        MessageWarn.send "Unknown protocol requested: #{@scheme}!"
      end
      @switched = true
    end

    def reset
      @scheme = DEFAULT
      @switched = false
    end

    def to_s
      @scheme.to_s
    end

    private

    attr_accessor :first_load

    PROTOCOLS = [:https, :http]
    DEFAULT   = PROTOCOLS.first

    def strip_url(url)
      PROTOCOLS.each do |protocol|
        url.gsub!(protocol.to_s << '://', '') if protocol_included? url, protocol
      end
    end

    def add_actual_protocol(url)
      url.replace "#{@scheme.to_s}://#{url}"
    end

    def protocol_included?(url, protocol)
      if protocol == :any
        PROTOCOLS.any? { |p| protocol_included? url, p }
      else
        (url =~ Regexp.new(protocol.to_s << '://')) == 0
      end
    end
  end # class ::InternetConnection::ConnectionProtocol
end # module TTWatcher::InternetConnection
end # module TTWatcher
