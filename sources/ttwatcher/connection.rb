# encoding: utf-8

module TTWatcher
  #
  # All internet connections going throw this class
  #
  class Connection
    include InternetConnection
    #
    # settings by default: redirect_allowed => true
    #
    def initialize(params = {})
      @client   = HTTPClient.new
      @scheme = Scheme.new()
      @settings = default_settings.merge params
    end

    #
    # input: string with url in any form: "https://site.com",
    # "site.com", "www.site.com", )
    #
    # output: for success ==> requested page
    #         for fail    ==> nil
    #
    def download_page(url)
      @scheme.normalization! url # note: mutates an url
      @responce = @client.get Addressable::URI.parse(url) # <<DO NOT TRUST IN +URI.decode+ >>
      if responce_ok?
        return @responce.body
      else
        return responce_analysis
      end
    rescue Errno::ECONNREFUSED # ==> Scheme not supported. Try another one.
      @scheme.switch
      retry
    rescue URI::InvalidURIError # ==> bad URI
      MessageWarn.send "impossible to download from: '#{url}' (bad URL)."
      return nil
    end

    private

    attr_reader :client, :scheme

    def default_settings
      { :redirect_allowed => true }
    end

    def page
      @responce.body
    end

    def responce_ok?
      @responce.code == 200
    end

    # todo: extend with more codes <<if need>>
    def responce_analysis
      case @responce.code
      when 301
        message_moved_permanently
      else
        MessageWarn.send "unknown responce code for #{self}: #{@responce.code}"
        nil
      end
    end

    def message_moved_permanently
      return nil unless @settings[:redirect_allowed]
      redirect_url = @responce.headers['Location']
      msg = 'Got redirect responce, but "location" field is missed!'
      raise ConnectionError, msg if redirect_url.nil? || redirect_url.empty?
      download_page redirect_url
    end

    class ConnectionError < StandardError; end
  end # class TTWatcher::Connection
end # module TTWatcher
