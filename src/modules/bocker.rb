module Bocker

    def self.db
        if @db == nil
            @db = SQLite3::Database.new('db/bocker.sqlite')
            @db.results_as_hash = true
        end
        return @db
    end

    def self.all
        db.execute('SELECT * FROM bocker')
    end

    def self.find(id) 
        db.execute('SELECT * FROM bocker WHERE id = ?', id).first
    end

    def self.add(name, author, description)
        db.execute('INSERT INTO bocker (name, author, description) VALUES (?,?,?)', name, author, description)
    end

    def self.delete(id)
        db.execute('DELETE FROM bocker WHERE id = ?', id)
    end

    def self.update(id, description)
        db.execute('UPDATE bocker SET description = ? WHERE id = ?', description, id)
    end

end