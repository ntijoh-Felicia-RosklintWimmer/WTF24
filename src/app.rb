require 'debug'
require_relative 'db/seed   '
class App < Sinatra::Base

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
        @user = db.execute('SELECT * FROM users WHERE id = ?', user_id) 
        erb :'profil/index' 
    end

    post '/user' do
        name = params['user']  
        mail = params['mail']
        query = 'INSERT INTO users (name, mail) VALUES (?,?) RETURNING id'
        result = db.execute(query, name, mail).first 
        redirect "/users/#{result['id']}" 
    end

    enable :sessions

    get '/' do
      session[:user_id] = 1 
    end
  
    get '/home' do
      user_id = session[:user_id] 
    end

#Sida 1.0
    #Se info om sidan
    #Länka till inloggning

#Sida 1.1 Skapa konto

#Sida 1.2 Logga in användare

#Sida 1.3 Logga in admin

#Sida 2.0 Alla böcker (tänk julkalendern)

#Sida 2.1 Bok med titel, komentarer, rekomendation

#Sida 3.0 Profil inloggad användare

#Sida 3.1 Profil admin

end