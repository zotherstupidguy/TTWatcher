# encoding: utf-8

module TTWatcher
module Sites
  #
  # Do not forget overload next methods: [optional] +connection_settings+
  #
  class Site
    attr_reader   :hostname   # <site name>
    attr_accessor :connection

    def initialize(name)
      @hostname = name
      @connection ||= TTWatcher::Connection.new(default_connection_settings)
      @parser = parser
    end

    #
    # <<USER ENDPOINT>>
    #
    #  Shows site name
    #
    def to_s
      @hostname
    end

    #
    # <<USER ENDPOINT>>
    #
    # generates part of url that includes site name + path
    #
    # example: input  ==> @root = "some.site.com", path = 'hello/world'
    #          output ==> "some.site.com/hello/world"
    #
    # if path not selected it returns +@root+
    #
    def address(path='')
      return @hostname if path.nil? || path.empty?
      return path if site_name_included?(path)

      path = '/' + path unless path[0] == '/'
      @hostname + path
    end

    #
    # <<USER ENDPOINT>>
    #
    # Set separate connection for each +Site+ instance.
    # Good if we want use proxies/multithreading somewhere in future.
    #
    def download(url, settings = {})
      url = address(url) unless site_name_included?(url)
      answer = @connection.download_page(url, settings)
      answer_analysis(answer)
    end

    private

    #
    # set specific connection settings (like scheme) if need.
    #
    def default_connection_settings; {} end # +abstract+

    #
    # output: <true>  if url includes site name
    #         <false> otherwise
    #
    def site_name_included?(url)
      (url =~ Regexp.new(@hostname.to_s + '/')) == 0
    end

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
      return if (new_url = Addressable::URI.parse(url).host) == @hostname

      MessageWarn.send "Redirected: address '#{@hostname}' has been changed to '#{new_url}'"
      @hostname = new_url
    end
  end # classTTWatcher::Sites::Site
end # module TTWatcher::Sites
end # module TTWatcher
