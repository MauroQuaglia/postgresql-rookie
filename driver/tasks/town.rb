#!/usr/bin/env ruby

require 'pg'

conn = PG.connect(host: '127.0.0.1', port: 2345, dbname: 'town', user: 'postgres')

conn.exec("SELECT * FROM school.courses;") do |result|
  result.each do |row|
    puts "ROW: #{row['course_id']} #{row['title']} #{row['hours']}"
  end
end

