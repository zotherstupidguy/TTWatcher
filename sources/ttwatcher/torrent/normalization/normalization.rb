# encoding: utf-8

module TTWatcher
module Torrents
module Normalization

  #
  #
  #
  def self.standardizate!(params)
    normalizer = normalizations_mapping[params[:tracker]]
    normalizer.mutate! params
  end

  #
  #
  #
  def self.normalizations_mapping
    @normalizations_mapping ||=
      begin
        tmp = Hash.new { |hash, key| hash[key] = Default }
        tmp.merge({ zooqle:    Zooqle,
                    rutor:     Rutor,
                    megashara: Megashara,
                    unionpeer: Unionpeer})
      end
  end
end # module TTWatcher::Torrents::Normalization
end # module TTWatcher::Torrents
end # module TTWatcher
