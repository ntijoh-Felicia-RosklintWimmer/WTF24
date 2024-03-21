require 'debug'
require_relative 'db/seed'
class App < Sinatra::Base

    enable :sessions

    def db
        if @db == nil
            @db = SQLite3::Database.new('db/bocker.sqlite')#Sätt in namnet på databasen
            @db.results_as_hash = true
        end
        return @db
    end
    

    get '/' do
        @result = db.execute('SELECT * FROM bocker')
        erb :'index'
    end

    get '/reseed' do
        Seeder.seed!
        redirect "/"
    end
    
    get '/user/:id' do |user_id|  
        @user = db.execute('SELECT * FROM users WHERE id = ?', user_id).first
        erb :'userpage' 
    end

    get '/signup' do
        erb :signup
    end

    get '/login' do
        erb :index
    end

    post '/user/signup' do
        name = params['user_name']
        mail = params['user_email']
        password = params['password']
        hashed_password = BCrypt::Password.create(password)
        id = db.execute('INSERT INTO users (name, mail, password) VALUES (?,?,?) RETURNING *', name, mail, hashed_password).first['id']
        session[:user_id] = id
        redirect "/user/#{id}" 
    end

    post '/user/login' do
        mail = params['user_email']
        password = params['password']
        user = db.execute('SELECT * FROM users WHERE mail = ?', mail).first
        
        if user == nil
            p "No user found"
            redirect "/user/login"
        end

        password_from_db = BCrypt::Password.new(user['password'])

        if password_from_db == password 
            session[:user_id] = user['id'] 
            redirect "/user/#{session[:user_id]}"
        else
            p "Failed login"
            redirect "/login/login"
        end
    end

    post '/user/logout' do 
        session.destroy
    end

    get '/users' do 
        redirect "/user/#{session[:user_id]}"
    end

#Sida 1.0
    #Se info om sidan
    get '/about' do
        erb :'om-oss/about'
    end
    #Länka till inloggning

#Sida 1.1 Skapa konto - Klart

#Sida 1.2 Logga in användare - fungerar inte riktigt

#Sida 1.3 Logga in admin

#Sida 2.0 Alla böcker (tänk julkalendern)

#Sida 2.1 Bok med titel, komentarer, rekomendation

#Sida 3.0 Profil inloggad användare

#Sida 3.1 Profil admin

end