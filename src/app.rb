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
    

    #Sida 1.1 Skapa konto/logga in - Klart
    get '/user/:id' do |user_id|  
        @user = db.execute('SELECT * FROM users WHERE id = ?', user_id).first
        # @bok_user = db.execute('SELECT * FROM bok_user WHERE Id = ?', session[:user_id])
        erb :'userpage'

    end

    get 'signup' do
        erb :'signup'
    end

    get 'login' do
        erb :'index'  
    end

    post '/user/signup' do
        name = params['user_name']
        mail = params['user_email']
        password = params['password']
        hashed_password = BCrypt::Password.create(password)
        id = db.execute('INSERT INTO users (name, mail, password) VALUES (?,?,?) RETURNING *', name, mail, hashed_password).first['id']
        session[:user_id] = id
        # redirect "/user/#{id}" #tidigare
        redirect "/user/#{id}" 
    end

    post '/user/login' do
        mail = params['user_email']
        password = params['password']
        user = db.execute('SELECT * FROM users WHERE mail = ?', mail).first
        
        if user == nil
            p "No user found"
            # redirect "/login/login" tidigare
            redirect "signup"
        end

        password_from_db = BCrypt::Password.new(user['password'])

        if password_from_db == password 
            session[:user_id] = user['id'] 
            redirect "/user/#{session[:user_id]}"
        else
            p "Failed login"
            redirect "/"
        end
    end

    post '/user/logout' do 
        session.destroy
        redirect "/"
    end
    
    get '/user' do 
        if session[:user_id] != nil
            redirect "/user/#{session[:user_id]}"
        else
            redirect "/"
        end
        
    end

#Sida 1.0
    #Se info om sidan
    get '/about' do
        erb :'about'
    end
    #Länka till inloggning

#Sida 1.3 Logga in admin - ej klart 

#Sida 2.0 Alla böcker 
    get '/bocker/new' do 
        if session[:user_id] != nil
            redirect 'bocker/new'
        else
            redirect "/bocker/index"
        end
    end

    get '/bocker/index' do 
        @bocker = db.execute('SELECT * FROM bocker')
        erb :'bocker/index'
    end

    get '/bocker/index/:bok' do |bok|
        print("id " + bok)
        @bocker = db.execute('SELECT * FROM bocker WHERE id = ?', bok)
        @sing = 1
        erb :'/bocker/index'
    end


    # Använd kortare routs som bara new
    # Skapa if satser så att formuläret inte ens är synligt för användare utan log in
    # Skapa mappar för olika funktioner i app
    # skapa mappar för olika new, add osv för comment, böcker, writers osv.
    post '/bocker/new' do 
        p params
        name = params['name']
        author = params['author']
        description = params['description']
        db.execute('INSERT INTO bocker (name, author, description) VALUES (?,?,?)', name, author, description)
        #result = db.execute(name, author, description).first 
        redirect "/bocker/new" 
    end

    get '/bocker/index/:id/edit' do |id| 
        if session[:user_id] == nil
            redirect "/bocker/index"
        end
        @bocker = db.execute('SELECT * FROM bocker WHERE id = ?', id.to_i).first
        erb :'bocker/edit'
    end 

    post '/bocker/index/:id/update' do |id| 
        if session[:user_id] == nil
            redirect "/"
        end
        bocker = params['content']
        db.execute('UPDATE bocker SET (content = ?) WHERE id = ?', bok, id)
        redirect "/bocker/index/#{id}" 
    end

    post '/bocker/index/:id/delete' do |id| 
        if session[:user_id] == nil
            redirect "/"
        end

        db.execute('DELETE FROM bocker WHERE id = ?', id)
        redirect "/bocker/"
    end

#Sida 2.1 Bok med titel, komentarer, rekomendation

#Sida 3.0 Profil inloggad användare
    # post '/user/profile' do 

    # end

#Sida 3.1 Profil admin

#Helps so no html works in comments

    # get '/comment/new' do 
    #     # ...
    # end

    # post '/comment/new' do 
    #     p params
    #     name = params['name']
    #     description = params['description']
    #     db.execute('INSERT INTO bok_user (name, description) VALUES (?,?)', name, description)
    #     #result = db.execute(name, author, description).first 
    #     redirect "/comment/new" 
    # end

    helpers do
        def h(text)
            Rack::Utils.escape_html(text)
        end

        def hattr(text)
            Rack::Utils.escape_path(text)
        end
    end

end