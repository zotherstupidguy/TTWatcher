# encoding: utf-8

module TTWatcher
  #
  #
  #
  class TorrentList
    include Enumerable

    # Register +push+ method
    #
    # Me want guarantee that TorrentList object is homogeneous.
    # It means only +Torrent+ instances allowed to been stored.
    #
    def push(other)
      case other
      when Torrent
        @torrents.send __method__, other
      when TorrentList
        @torrents += other.to_a
      else
        raise UnexpectedClass.new other
      end
      self
    end

    alias :<< :push
    alias :+  :push

    def initialize
      @torrents = []
    end

    def each(&block)
      @torrents.each do |obj|
        block.call obj
      end
    end

    #
    # this supposed to been raised when we trying to put into storage not
    # +Torrent+ or +TorrentList+ instance.
    #
    class UnexpectedClass < StandardError
      def initialize(arg); super "Expected to get Torrent (or TorrentList) instance, but got #{arg.class} instance"; end end
  end # class TTWatcher::TorrentList
end # module TTWatcher
