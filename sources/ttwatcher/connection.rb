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
      default_settings params
    end

    def deep_merge(a, b)
      a.merge! b {}
    end

    #
    # input: url [string] in any form: "https://site.com",
    #                                  "site.com",
    #                                  "www.site.com"
    #
    # output: if <ok>    : requested page (unparsed html)
    #         if <error> : nil
    #
    def download_page(text, settings = {})
      local_settings = default_settings.deep_merge(settings)
      url = Url.new(text, local_settings[:url] )
      @responce = client.execute(method: :get, url: url.to_s, max_redirects: 0)
      return responce_analysis

    rescue Errno::ECONNREFUSED # ==> Scheme not supported. Try another one.
      url.scheme_switch
      retry

    rescue RestClient::Found, RestClient::MovedPermanently => exception # ==> add custom reaction for redirect responce
      @responce = exception.response
      return responce_analysis

    rescue URI::InvalidURIError # ==> bad URI
      MessageWarn.send "impossible to download from: '#{url.to_s}' (bad URL)."
      return nil

    rescue RestClient::Forbidden
      MessageWarn.send "Connection for '#{url.to_s}' Forbidden."
      return nil
    end

    private
    #
    # Switched from <<HTTPClient>> because sometimes it can lose russians symbols
    # in headers['location'] (for +redirect+ message)
    #
    def client
      @client ||= RestClient::Request
    end

    def default_settings(params = {})
      @settings ||= { :redirect_allowed => true }.merge params
    end

    def responce_analysis
      case @responce.code
      when 200
        message_body
      when 301, 302
        message_moved_permanently
      else
        MessageWarn.send "unknown responce code for #{self}: #{@responce.code}"
        nil
      end
    end

    def message_moved_permanently
      return nil unless @settings[:redirect_allowed]

      redirect_url = @responce.headers[:location]
      raise ConnectionError if redirect_url.nil? || redirect_url.empty?

      answer = download_page(redirect_url)
      answer = answer[:output] while answer.is_a? Hash # extract page after multi-redirection

      { notes: { redirect: redirect_url }, output: answer.encode('utf-8') }
    end

    def message_body
      @responce.body.encode('utf-8')
    end

    class ConnectionError < StandardError;
      def initialize; super 'Got redirect responce, but "location" field is missed!'; end; end
  end # class TTWatcher::Connection
end # module TTWatcher
