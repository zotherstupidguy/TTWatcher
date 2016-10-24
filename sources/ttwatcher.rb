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

  # project structure

  require_relative 'ttwatcher/connection/scheme'
  require_relative 'ttwatcher/connection/url'
  require_relative 'ttwatcher/message'
  require_relative 'ttwatcher/connection'
  require_relative 'ttwatcher/torrent'

  require_relative 'ttwatcher/sites/parsers/parse'
  require_relative 'ttwatcher/sites/parsers/rutor_parser'
  require_relative 'ttwatcher/sites/parsers/rutracker_parser'
  require_relative 'ttwatcher/sites/parsers/tfile_parser'

  require_relative 'ttwatcher/sites/site'
  require_relative 'ttwatcher/sites/torrent_site'
  require_relative 'ttwatcher/sites/rutor'
  require_relative 'ttwatcher/sites/tfile'
  require_relative 'ttwatcher/sites/rutracker'
  require_relative 'ttwatcher/sites'

  require_relative 'ttwatcher/torrent_agent'

  def self.start
    torrents = TorrentAgent.find 'кот'
#    puts Sites::LIST
    if torrents
     torrents.each do |t|
       puts t.name
       puts t.url
       puts t.size
       puts t.tracker
       puts '-------------'
     end
    end

  end
end # module TTWatcher

TTWatcher.start
