# encoding: utf-8

module TTWatcher
  require_relative 'ttwatcher/project_structure'

  #
  #
  #
  def self.find(name, params ={})
    torrents = TorrentAgent.find(name)
  end

  #
  #
  #
  def self.find_book(name, params ={})
    torrents = TorrentAgent.find(name)
    torrents.select { |t| t.type == :book }
  end

  #
  #
  #
  def self.find_program(name, params ={})
    torrents = TorrentAgent.find(name)
    torrents.select { |t| t.type == :soft }
  end

  #
  #
  #
  def self.find_video(name, params ={})
    torrents = TorrentAgent.find(name)
    torrents.select { |t| t.type == :video }
  end

  #
  #
  #
  def self.find_game(name, params ={})
    torrents = TorrentAgent.find(name)
    torrents.select { |t| t.type == :game }
  end
end # module TTWatcher
