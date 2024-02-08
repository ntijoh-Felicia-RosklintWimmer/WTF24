require 'sqlite3'

def db
    if @db == nil
        @db = SQLite3::Database.new('./db/db-sqliteböcker.db')
        @db.results_as_hash = true
    end
    return @db
end

class Seeder
    def self.seed!
        puts "Seeding the DB"
        drop_tables
        create_tables
        seed_data
        puts "Seed complete"
    end
end