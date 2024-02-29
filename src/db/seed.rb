require 'sqlite3'
class Seeder
    def self.db
        if @db == nil
            @db = SQLite3::Database.new('./db/bocker.sqlite')
            @db.results_as_hash = true
        end
        return @db
    end

    def self.drop_tables
        db.execute('DROP TABLE IF EXISTS bocker')
    end

    def self.create_tables
        db.execute('CREATE TABLE bocker(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT
        )')
    end

    def self.seed_data
    end

    def self.seed!
        puts "Seeding the DB"
        drop_tables
        create_tables
        seed_data
        puts "Seed complete"
    end
end

Seeder.seed!