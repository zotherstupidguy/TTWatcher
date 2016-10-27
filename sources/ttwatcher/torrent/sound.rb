# encoding: utf-8

module TTWatcher
  class SoundTorrent < Torrent
    class << self
      #
      #
      #
      def build(**params)
        new params
      end

      private

      def sub_types # todo: add sub-types! <note: if need>
      end
    end # class << self

    # --------------------INSTANCE ZONE-------------------

    private_class_method :sub_types

    #
    #
    #
    def sub_class_initialization(**params); end
  end # class TTWatcher::SoundTorrent
end # module TTWatcher
