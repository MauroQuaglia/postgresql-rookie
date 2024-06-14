#!/usr/bin/env ruby

require 'pg'
conn = PG.connect(host: '127.0.0.1', port: 2345, dbname: 'town', user: 'postgres')

category = ARGV[0]
puts("SETTINGS FOR #{category}:")

conn.exec("SELECT name, setting FROM pg_settings where category ILIKE '%#{category}%';") do |result|
  result.each do |row|
    puts "#{row['name']}: #{row['setting']}"
  end
end
