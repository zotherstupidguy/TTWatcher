# encoding: utf-8

require_relative '../sources/ttwatcher'

search_text = 'учебник'

torrents = TTWatcher.find search_text

puts '-----' * 20
puts "search phrase:  #{search_text}"
puts "totally found:  #{torrents.count}", ""
puts "from megashara: #{torrents.select { |t| t.tracker == :megashara }.count }"
puts "from rutor.org: #{torrents.select { |t| t.tracker == :rutor }.count     }"
puts "from unionpeer: #{torrents.select { |t| t.tracker == :unionpeer }.count }"
puts "from zooqle:    #{torrents.select { |t| t.tracker == :zooqle }.count    }"
puts '-----' * 20

torrents.each do |t|
  puts "name:         #{t.name}"         if t.name
  puts "type:         #{t.type}"         if t.type
  puts "description:  #{t.description}"  if t.description
  puts "url:          #{t.url}"          if t.url
  puts "size:         #{t.size}"         if t.size
  puts "author:       #{t.author}"       if t.author
  puts "added_date:   #{t.added_date}"   if t.added_date
  puts "seeders:      #{t.seeders}"      if t.seeders
  puts "leeches:      #{t.leeches}"      if t.leeches
  puts "magnet_url:   #{t.magnet_url}"   if t.magnet_url
  puts "download_url: #{t.download_url}" if t.download_url
  puts "torrent_page: #{t.torrent_page}" if t.torrent_page
  puts "tracker:      #{t.tracker}"      if t.tracker
  puts '-----' * 20
end
