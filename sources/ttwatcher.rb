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
  require 'abstract'

  class << self
    private

    def self.load(**params)
      params[:files].each do |f|
        require File.join(__dir__, 'ttwatcher', params[:folder].to_s, f)
      end
    end

    # project structure

    load folder: 'torrent/normalization',
         files: %w(abstract_normalizer default megashara rutor unionpeer zooqle normalization)

    load folder: 'connection',
         files: %w(scheme url proxy)

    load files: %w(message connection torrent)

    load folder: 'torrent',
         files: %w(torrent_list book game other soft sound unknown video torrents)

    load folder: 'sites/parsers',
         files: %w(abstract_parser simple_parser)

    load folder: 'sites/parsers',
         files: %w(rutor_parser megashara_parser unionpeer_parser zooqle_parser)

    load folder: 'sites',
         files: %w(site torrent_site rutor megashara unionpeer zooqle)

    load files: %w(sites torrent_agent)
  end # class << self

  # --------------------INSTANCE ZONE-------------------

  #
  # TODO: add public interface and description
  #
end # module TTWatcher
