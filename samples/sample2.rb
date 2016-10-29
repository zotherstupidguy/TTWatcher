# encoding: utf-8

require_relative '../sources/ttwatcher'

search_text = 'леопольд'

torrents = TTWatcher.find_video search_text

 torrents.each do |t|
   puts "name:         #{t.name}\n"         if t.name
   puts "description:  #{t.description}\n"  if t.description
   puts "url:          #{t.url}\n"          if t.url
   puts "size:         #{t.size}\n"         if t.size
   puts "author:       #{t.author}\n"       if t.author
   puts "added_date:   #{t.added_date}\n"   if t.added_date
   puts "seeders:      #{t.seeders}\n"      if t.seeders
   puts "leeches:      #{t.leeches}\n"      if t.leeches
   puts "magnet_url:   #{t.magnet_url}\n"   if t.magnet_url
   puts "download_url: #{t.download_url}\n" if t.download_url
   puts "torrent_page: #{t.torrent_page}\n" if t.torrent_page
   puts "tracker:      #{t.tracker}\n"      if t.tracker
   puts  '-----' * 20 + "\n"
 end

