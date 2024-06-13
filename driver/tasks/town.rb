#!/usr/bin/env ruby

require 'pg'
require 'json'

conn = PG.connect(host: '127.0.0.1', port: 2345, dbname: 'town', user: 'postgres')

conn.exec("SELECT version();") do |result|
  result.each do |row|
    puts row['version']
  end
end

conn.exec("SELECT * FROM pg_settings;") do |result|
  result.each do |row|
    File.open("./data/v10/pg_settings/#{row['name']}.json", 'w') do |file|
      file.write(JSON.generate(row))
    end
  end
end