#!/usr/bin/env ruby

require 'pg'
require 'json'

conn = PG.connect(host: '127.0.0.1', port: 2345, dbname: 'town', user: 'postgres')

conn.exec("SELECT version();") do |result|
  result.each do |row|
    puts row['version']
  end
end

# I pg_setting sono le configurazioni del server PostgreSQL in generale.
# Mentre pg_catalog e information_schema sono quelle dei vari DB.
# pg_catalog è più completo rispetto a information_schema.
conn.exec("SELECT * FROM pg_settings;") do |result|
  result.each do |row|
    File.open("./data/v10/pg_settings/#{row['name']}.json", 'w') do |file|
      file.write(JSON.generate(row))
    end
  end
end