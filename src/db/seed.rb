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
        db.execute('DROP TABLE IF EXISTS users')
    end

    def self.create_tables
        db.execute('CREATE TABLE bocker(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT
        )')
        db.execute('CREATE TABEL Writers(
            "id"	INTEGER UNIQUE,
            "Name"	TEXT NOT NULL,
            PRIMARY KEY("id")'
        )
        db.execute('CREATE TABLE "bok_wri" (
            "id"	INTEGER,
            "Bok"	TEXT NOT NULL,
            "Author"	TEXT NOT NULL,
            PRIMARY KEY("id")'
        )
        db.execute('CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            mail TEXT NOT NULL,
            password TEXT NOT NULL
        )')
        db.execute('CREATE TABLE "bok_user" (
            "id"	INTEGER,
            "comment"	TEXT NOT NULL,
            "rating"	INTEGER NOT NULL,
            "username"   TEXT NOT NULL,
            PRIMARY KEY("id")'
        )
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