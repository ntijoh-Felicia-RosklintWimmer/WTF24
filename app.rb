require 'debug'
class App < Sinatra::Base

    def db
        if @db == nil
            @db = SQLite3::Database.new('...')#Sätt in namnet på databasen
            @db.results_as_hash = true
        end
        return @db
    end