module User

    def self.db
        if @db == nil
            @db = SQLite3::Database.new('db/bocker.sqlite')
            @db.results_as_hash = true
        end
        return @db
    end

    def self.get_user_info(id)
        db.execute('SELECT * FROM users WHERE id = ?', id).first
    end

    def self.login(mail, password)
        # Retreive all the user info
        user = db.execute('SELECT * FROM users WHERE mail = ? ', mail).first

        # db.execute('INSERT INTO users (name, password) VALUES (?,?) RETURNING *', name, password).first['id']
        hashed_password = BCrypt::Password.create(password)     

        if BCrypt::Password.new(user['password']) == password
            return user['id']
        end
    end

    def self.register(name, mail, password)   
        return db.execute('INSERT INTO users (name, mail, password) VALUES (?,?,?) RETURNING *', name, mail, password).first['id']
    end

    
end