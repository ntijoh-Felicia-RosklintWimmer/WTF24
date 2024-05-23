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

    helpers do
        def h(text)
            Rack::Utils.escape_html(text)
        end

        def hattr(text)
            Rack::Utils.escape_path(text)
        end
    end

    get '/' do
        @result = Book.all()# db.execute('SELECT * FROM bocker')
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

    get '/signup' do
        erb :'signup'
    end

    get 'login' do
        erb :'index'  
    end

    post '/signup' do
        name = params['user_name']
        mail = params['user_email']
        password = params['password']
        hashed_password = BCrypt::Password.create(password)
        id = db.execute('INSERT INTO users (name, mail, password) VALUES (?,?,?) RETURNING *', name, mail, hashed_password).first['id']
        session[:user_id] = id
        redirect "/user/#{id}" 
    end

    post '/login' do
        mail = params['user_email']
        password = params['password']
        user = db.execute('SELECT * FROM users WHERE mail = ?', mail).first
        
        if user == nil
            p "No user found"
            # redirect "/login/login" tidigare
            redirect "/signup"
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

    post '/logout' do 
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

#Sida 1.3 Logga in admin - ej klart 

#Sida 2.0 Alla böcker 
    get '/bocker/new' do 
        redirect "/bocker/index" unless session[:user_id]      
        erb :'/bocker/new'
    end

    get '/bocker/index' do 
        @bocker = db.execute('SELECT * FROM bocker')
        erb :'bocker/index'
    end

    get '/bocker/index/:bok' do |bok|
        if session[:user_id] != nil
            @userCheck = 1
        else
            @userCheck = 0
        end
        print("id " + bok)
        @bocker = db.execute('SELECT * FROM bocker WHERE id = ?', bok)
        @sing = 1
        @comments = db.execute('SELECT * FROM bok_user WHERE bok_id = ?', bok)
        erb :'/bocker/index'
    end


    # Använd kortare routs som bara new
    # Skapa mappar för olika funktioner i app
    # skapa mappar för olika new, add osv för comment, böcker, writers osv.
    post '/bocker/new' do 
        if session[:user_id] == nil
            redirect "/"
        end        name = params['name']
        author = params['author']
        description = params['description']
        db.execute('INSERT INTO bocker (name, author, description) VALUES (?,?,?)', name, author, description)
        #result = db.execute(name, author, description).first 
        redirect "/bocker/index" 
    end

   
    get '/bocker/:id/edit' do |id| 
        @bocker = db.execute('SELECT * FROM bocker WHERE id = ?', id.to_i).first
        erb :'bocker/edit'
      end

    post '/bocker/index/:id/update' do |id| 
        if session[:user_id] == nil
            redirect "/"
        end
        id = params["id"]
        description = params["description"]
        db.execute('UPDATE bocker SET description = ? WHERE id = ?', description, id)
        redirect "/bocker/index/#{id}" 
    end

    post '/bocker/index/:id/delete' do |id| 
        if session[:user_id] == nil
            redirect "/"
        end
        db.execute('DELETE FROM bocker WHERE id = ?', id)
        db.execute('DELETE FROM bok_user WHERE bok_id = ?', id)
        redirect "/bocker/index"
    end

    post '/comments/new' do 
        if session[:user_id] == nil
            redirect "/"
        end
        p params
        name = params['username']
        bok_id = params['bok_id']
        comment = params['comment']
        rating = params['rating']
        db.execute('INSERT INTO bok_user (name, bok_id, comment, rating) VALUES (?,?,?,?)', name, bok_id, comment, rating)
        #result = db.execute(name, author, description).first 
        redirect "/bocker/index" 
    end

end