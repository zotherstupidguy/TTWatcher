# encoding: utf-8

module TTWatcher
module Torrents
module Normalization
  #
  #
  #
  module Helpers
    #
    #
    #
    def load_formats
      return @json_format_helper if @json_format_helper
      f = File.open(File.join(__dir__, 'formats.json'), 'r')
      (data = f.read) && (f.close)
      @json_format_helper = JSON.parse data
    end

    #
    #
    #
    def conversion_calculator(word)
      case word.to_s.downcase
      when 'tb', 'тб'
        1024**4
      when 'gb', 'гб'
        1024**3
      when 'mb', 'мб'
        1024**2
      when 'kb', 'кб'
        1024
      else
        1
      end
    end
  end # module Normalization::Helpers
end # module Torrents::Normalization
end # module TTWatcher::Torrents
end # module TTWatcher
