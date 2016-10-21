# encoding: utf-8

module TTWatcher
  # dependencies from core lib

  require 'forwardable'
  require 'singleton'
  require 'logger'

  # dependencies from rubygems.org

  require "addressable/uri"
  require 'nokogiri'
  require 'httpclient'

  # project structure

  require_relative 'ttwatcher/message'
  require_relative 'ttwatcher/connection/scheme'
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

  def self.start
    #site = TTWatcher::Connection.new
    site = Site::RUTOR
    torrents = site.find_torrent('маша')

    torrents.each do |t|
      puts t.name
      puts t.url
    end
    #result = site.download_page "new-ru.org"
    #result = site.download_page 'rutor.is' # rutor.is
    #puts result
  end

end # module TTWatcher

TTWatcher.start
