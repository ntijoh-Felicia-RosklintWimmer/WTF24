module Comment

    def self.db
        if @db == nil
            @db = SQLite3::Database.new('db/bocker.sqlite')
            @db.results_as_hash = true
        end
        return @db
    end

    def self.create(name, bok_id, comment, rating)
        db.execute('INSERT INTO bok_user (name, bok_id, comment, rating) VALUES (?,?,?,?)', name, bok_id, comment, rating)
    end

    def self.delete(id)
        db.execute('DELETE FROM bok_user WHERE bok_id = ?', id)
    end


    def self.find(id)
        db.execute('SELECT * FROM bok_user WHERE bok_id = ?', id)
    end
end