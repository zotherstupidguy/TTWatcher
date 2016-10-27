# encoding: utf-8

module TTWatcher
  # dependencies from core lib

  require 'forwardable'
  require 'singleton'
  require 'logger'

  # dependencies from rubygems.org

  require "addressable/uri"
  require 'nokogiri'
  require 'rest-client'
  require 'deep_merge'

  # project structure

  require_relative 'ttwatcher/torrent/normalization/abstract_normalizer'
  require_relative 'ttwatcher/torrent/normalization/default'
  require_relative 'ttwatcher/torrent/normalization/megashara'
  require_relative 'ttwatcher/torrent/normalization/rutor'
  require_relative 'ttwatcher/torrent/normalization/unionpeer'
  require_relative 'ttwatcher/torrent/normalization/zooqle'
  require_relative 'ttwatcher/torrent/normalization/normalizations'

  require_relative 'ttwatcher/connection/scheme'
  require_relative 'ttwatcher/connection/url'
  require_relative 'ttwatcher/message'
  require_relative 'ttwatcher/connection'
  require_relative 'ttwatcher/torrent'

  require_relative 'ttwatcher/torrent/torrent_list'
  require_relative 'ttwatcher/torrent/book'
  require_relative 'ttwatcher/torrent/game'
  require_relative 'ttwatcher/torrent/other'
  require_relative 'ttwatcher/torrent/soft'
  require_relative 'ttwatcher/torrent/sound'
  require_relative 'ttwatcher/torrent/unknown'
  require_relative 'ttwatcher/torrent/video'
  require_relative 'ttwatcher/torrent/torrents'

  require_relative 'ttwatcher/sites/parsers/abstract_parser'
  require_relative 'ttwatcher/sites/parsers/simple_parser'

  require_relative 'ttwatcher/sites/parsers/rutor_parser'
  require_relative 'ttwatcher/sites/parsers/megashara_parser'
  require_relative 'ttwatcher/sites/parsers/unionpeer_parser'
  require_relative 'ttwatcher/sites/parsers/zooqle_parser'

  require_relative 'ttwatcher/sites/site'
  require_relative 'ttwatcher/sites/torrent_site'

  require_relative 'ttwatcher/sites/rutor'
  require_relative 'ttwatcher/sites/megashara'
  require_relative 'ttwatcher/sites/unionpeer'
  require_relative 'ttwatcher/sites/zooqle'

  require_relative 'ttwatcher/sites'

  require_relative 'ttwatcher/torrent_agent'

  # todo: write simple autoload/dependency manager
end # module TTWatcher
