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
