# encoding: utf-8

module TTWatcher
module Sites
  class Site
    attr_reader :hostname, :connection, :name

    def initialize(hostname, name=nil)
      @hostname = hostname
      @name = name || hostname.to_sym
      @connection ||= TTWatcher::Connection.new(default_connection_settings)
    end

    #
    # <<USER ENDPOINT>>
    #
    # Shows site hostname
    #
    def to_s
      hostname
    end

    #
    # <<USER ENDPOINT>>
    #
    # generates url that includes scheme + site name + +path+ (optional)
    #
    # example: input  ==> @hostname = "some.site.com", path = 'hello/world'
    #          output ==> "http://some.site.com/hello/world"
    #
    # if path not selected it returns scheme + +@hostname+
    #
    def address(path='')
      scheme = connection.last_used_url.scheme
      if !path.empty? && site_name_included?(path)
        InternetConnection::Scheme.add_scheme!(path, scheme)
      else
        hn = hostname.dup # prevent unnecessary +hostname+ mutation
        InternetConnection::Scheme.add_scheme!(hn, scheme)
        path = '/' + path unless path[0] == '/'
        hn + path
      end
    end

    #
    # <<USER ENDPOINT>>
    #
    # Set separate connection for each +Site+ instance.
    # Good if we want use proxies/multithreading somewhere in future.
    #
    def download(url, settings = {})
      url = address(url) unless site_name_included?(url)
      answer = connection.download_page(url, settings)
      answer_analysis answer
    end

    private

    #
    # output: HASH with connection settings
    #
    # list of all key/value pairs that method +default_connection_settings+
    # _can_ return:
    #
    #     output[:url][:force_scheme] ==> :http or :https
    #     output[:url][:encoding]     ==>  Encoding::UTF8
    #
    # By default it should return empty hash
    #
    abstract_method :default_connection_settings

    # <Helper>
    #
    # output: <true>  if url includes site name
    #         <false> otherwise
    #
    def site_name_included?(url)
      (url =~ Regexp.new(hostname.to_s + '/')) == 0
    end

    #
    # ------------------ DO NOT OVERLOAD -------------------
    #

    #
    # In normal state it just return same thing that +download_page+ method
    # does.
    #
    # But also it allow be more flexible for situations where we need to
    # change object state (for example switch proxy if getting bad responce)
    #
    # input: answer as [HASH]   there something that need specific reaction
    #        answer as [STRING] normal answer / no special reaction need
    #        answer as [NIL]    normal answer / no special reaction need
    #
    # output: for success ==> requested page (unparsed html)
    #         for fail    ==> nil
    #
    def answer_analysis(answer)
      return answer if answer.nil? || answer.is_a?(String)
      if answer[:notes]
        check_if_hostname_changed answer[:notes][:redirect]
      end
      answer[:output]
    end

    def check_if_hostname_changed(url)
      return unless url

      # no reaction if +@hostname+ was not changed after redirect
      return if (new_url = Addressable::URI.parse(url).host) == hostname

      MessageWarn.send "Redirected: address '#{hostname}' has been changed to '#{new_url}'"
      @hostname = new_url
    end
  end # classTTWatcher::Sites::Site
end # module TTWatcher::Sites
end # module TTWatcher
