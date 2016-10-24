# encoding: utf-8

module TTWatcher
  #
  # All internet connections going throw this class
  #
  class Connection
    include InternetConnection
    #
    # input: redirect_allowed => true
    #        params [hash][optional] hash with optional params
    #
    def initialize(params = {})
      @settings = default_settings.merge params
    end

    #
    # input: url [string] in any form: "https://site.com",
    #                                  "site.com",
    #                                  "www.site.com"
    #
    # output: if <ok>    : requested page (unparsed html)
    #         if <error> : nil
    #
    def download_page(text)
      url = Url.new text, settings[:url] || {}
      @responce = client.execute(method: :get, url: url.to_s, max_redirects: 0)
      return responce_analysis

    rescue Errno::ECONNREFUSED # ==> Scheme not supported. Try another one.
      url.scheme_switch
      retry

    rescue RestClient::MovedPermanently => exception # ==> add custom reaction
                                                     # for redirect responce
      @responce = exception.response
      return responce_analysis

    rescue URI::InvalidURIError # ==> bad URI
      MessageWarn.send "impossible to download from: '#{url.to_s}' (bad URL)."
      return nil
    end

    private

    attr_reader :settings

    #
    # Switched from <<HTTPClient>> because sometimes it can lose russians symbols
    # in headers['location'] (for +redirect+ message)
    #
    def client
      @client ||= RestClient::Request
    end

    def default_settings
      { :redirect_allowed => true }
    end

    def responce_analysis
      case @responce.code
      when 200
        message_body
      when 301
        message_moved_permanently
      else
        MessageWarn.send "unknown responce code for #{self}: #{@responce.code}"
        nil
      end
    end

    def message_moved_permanently
      return nil unless @settings[:redirect_allowed]
      redirect_url = @responce.headers[:location]
      msg = 'Got redirect responce, but "location" field is missed!'
      raise ConnectionError, msg if redirect_url.nil? || redirect_url.empty?
      answer = download_page(redirect_url)

      {notes: {redirect: redirect_url}, output: answer}
    end

    def message_body
      @responce.body
    end

    class ConnectionError < StandardError; end
  end # class TTWatcher::Connection
end # module TTWatcher
