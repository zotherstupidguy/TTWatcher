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

  require_relative 'ttwatcher/connection/scheme'
  require_relative 'ttwatcher/connection/url'
  require_relative 'ttwatcher/message'
  require_relative 'ttwatcher/connection'
  require_relative 'ttwatcher/torrent'

  require_relative 'ttwatcher/sites/parsers/abstract_parser'
  require_relative 'ttwatcher/sites/parsers/simple_parser'

  require_relative 'ttwatcher/sites/parsers/rutor_parser'
  require_relative 'ttwatcher/sites/parsers/megashara_parser'
  require_relative 'ttwatcher/sites/parsers/unionpeer_parser'

  require_relative 'ttwatcher/sites/site'
  require_relative 'ttwatcher/sites/torrent_site'
  require_relative 'ttwatcher/sites/rutor'
  require_relative 'ttwatcher/sites/megashara'
  require_relative 'ttwatcher/sites/unionpeer'
  require_relative 'ttwatcher/sites'

  require_relative 'ttwatcher/torrent_agent'
end # module TTWatcher
