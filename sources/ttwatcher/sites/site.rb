# encoding: utf-8

module TTWatcher
module Sites
  class Site

    def to_s
      @root
    end

    def address(path='')
      return @root if path.empty?

      path = '/' + path unless path[0] == '/'
      @root + path
    end

    def initialize(name)
      @root = name
      @connection ||= TTWatcher::Connection.new
      @parser = parser
    end

    def download(url)
      @connection.download_page url
    end

    private

    def parser; end

    attr_reader :root
  end # classTTWatcher::Sites::Site
end # module TTWatcher::Sites
end # module TTWatcher
