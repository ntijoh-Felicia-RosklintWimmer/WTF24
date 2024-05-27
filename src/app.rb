require 'debug'
require_relative 'db/seed'

require_relative './modules/user'
require_relative './modules/bocker'
require_relative './modules/comment'
class App < Sinatra::Base

    enable :sessions

    helpers do
        def h(text)
            Rack::Utils.escape_html(text)
        end

        def hattr(text)
            Rack::Utils.escape_path(text)
        end
    end

    # get '/' do
    #     @result = db.execute('SELECT * FROM bocker')
    #     erb :'index'
    # end

    get '/' do
        # @user = User.find(session[:user_id])
        # @result = Bocker.all
        if session[:user_id] != nil
            @user = User.get_user_info(session[:user_id])
        end

        erb :'index'
    end


    get '/reseed' do
        Seeder.seed!
        redirect "/"
    end
    
    get '/signup' do 
        erb :'signup'
    end    

    post '/signup' do 
        # Retrieve the username and password from the form
        name = params['name']
        mail = params['user_email']
        password = params['password']
        # password_confirm = params["confirm_password"]

        # Check if passwords match
        # if password != password_confirm
        #     session[:error_message] = "Passwords do not match"
        #     redirect '/register'
        # end
        hashed_password = BCrypt::Password.create(password)     
        id = User.register(name, mail, BCrypt::Password.create(password))
        session[:user_id] = id
        redirect "/userpage/#{id}" 
    end

    get '/login' do 
        erb :'/'
    end

    post '/login' do 
        # Retrieve the username and password from the form
        mail = params['user_email']
        password = params['password']
        user_id = User.login(mail, password)
        if (user_id)
            session[:user_id] = user_id      
            redirect "/userpage/#{user_id}" 
        else
            session[:error_message] = "Password is incorrect"
            redirect '/'        
        end
    end

    get '/userpage/:id' do |id|
        if session[:user_id] != nil
            @user = User.get_user_info(session[:user_id])
        end
        @user = User.get_user_info(id)
        erb :userpage
    end

    get '/logout' do
        if session[:user_id] != nil
            logout = User.logout
        end
        redirect '/'
    end

    post '/logout'do 
        if session[:user_id] != nil
            session.destroy
        end
        redirect '/'
    end











#     get '/user/:id' do |user_id|  
#         @user = User.find(user_id)
#         # @bok_user = db.execute('SELECT * FROM bok_user WHERE Id = ?', session[:user_id])
#         erb :'userpage'
#     end

#     get '/signup' do
#         erb :'signup'
#     end

#     get 'login' do
#         erb :'index'  
#     end

#     post '/signup' do
#         name = params['user_name']
#         mail = params['user_email']
#         password = params['password']
#         hashed_password = BCrypt::Password.create(password)
#         id = db.execute('INSERT INTO users (name, mail, password) VALUES (?,?,?) RETURNING *', name, mail, hashed_password).first['id']
#         session[:user_id] = id
#         redirect "/user/#{id}" 
#     end

#     post '/login' do
#         mail = params['user_email']
#         password = params['password']
#         user = db.execute('SELECT * FROM users WHERE mail = ?', mail).first
        
#         if user == nil
#             p "No user found"
#             # redirect "/login/login" tidigare
#             redirect "/signup"
#         end

#         password_from_db = BCrypt::Password.new(user['password'])

#         if password_from_db == password 
#             session[:user_id] = user['id'] 
#             redirect "/user/#{session[:user_id]}"
#         else
#             p "Failed login"
#             redirect "/"
#         end
#     end

#     post '/logout' do 
#         session.destroy
#         redirect "/"
#     end
    
#     get '/user' do 
#         if session[:user_id] != nil
#             redirect "/user/#{session[:user_id]}"
#         else
#             redirect "/"
#         end
        
#     end

# #Sida 1.0
#     #Se info om sidan
    get '/about' do
        if session[:user_id] != nil
            @user = User.get_user_info(session[:user_id])
        end
        erb :'about'
    end

#Sida 1.3 Logga in admin - ej klart 

#Sida 2.0 Alla böcker 
    get '/bocker/new' do 
        redirect "/bocker/index" unless session[:user_id]      
        erb :'/bocker/new'
    end

    get '/bocker/index' do 
        if session[:user_id] != nil
            @user = User.get_user_info(session[:user_id])
        end
        @bocker = Bocker.all
        erb :'bocker/index'
    end

    get '/bocker/index/:bok' do |bok|
        if session[:user_id] != nil
            @userCheck = 1
        else
            @userCheck = 0
        end
        print("id " + bok)
        @bocker = [Bocker.find(bok)]
        @sing = 1
        @comments = Comment.find(bok)
        @comment = Comment.find(bok)
        erb :'/bocker/index'
    end


    # Använd kortare routs som bara new
    # Skapa mappar för olika funktioner i app
    # skapa mappar för olika new, add osv för comment, böcker, writers osv.
    # post '/bocker/new' do 
    #     if session[:user_id] == nil
    #         redirect "/"
    #     end        
    #     name = params['name']
    #     author = params['author']
    #     description = params['description']
    #     db.execute('INSERT INTO bocker (name, author, description) VALUES (?,?,?)', name, author, description)
    #     #result = db.execute(name, author, description).first 
    #     redirect "/bocker/index" 
    # end

   
    # get '/bocker/:id/edit' do |id| 
    #     @bocker = db.execute('SELECT * FROM bocker WHERE id = ?', id.to_i).first
    #     erb :'bocker/edit'
    # end

    # post '/bocker/index/:id/update' do |id| 
    #     if session[:user_id] == nil
    #         redirect "/"
    #     end
    #     @Bok = Bocker.edit
    #     redirect "/bocker/index/#{id}" 
    # end


    #create a book

    get '/bocker/new' do
        erb :'bocker/new'
    end

    post '/bocker/new' do
        if (session[:user_id] != nil)
            name = params["name"]
            author = params["author"] 
            description = params["description"]
            bok_id = Bocker.add(name, author, description)
            redirect "/bocker/index"
        end    
        redirect "/bocker/index"
    end

    post '/bocker/index/:id/delete' do |id| 
        Bocker.delete(id)
        Comment.delete(id)
        redirect "/bocker/index"
    end
        
    get '/bocker/:id/edit' do |id|
        @Bocker = Bocker.find(id)
        erb :'bocker/edit'    
    end

    post '/bocker/index/:id/update' do |id|
        description = params["description"]
        Bocker.update(id, description)
        redirect "/bocker/index/" + id
    end

    get '/bocker/view/:id' do |id|
        @bok_id = Bocker.find(id)
        erb :'bocker/index'
    end

    # post '/bocker/index/:id/delete' do |id| 
    #     if session[:user_id] == nil
    #         redirect "/"
    #     end
    #     db.execute('DELETE FROM bocker WHERE id = ?', id)
    #     db.execute('DELETE FROM bok_user WHERE bok_id = ?', id)
    #     redirect "/bocker/index"
    # end


    # post '/comments/new' do 
    #     if session[:user_id] == nil
    #         redirect "/"
    #     end
    #     p params
    #     name = params['username']
    #     bok_id = params['bok_id']
    #     comment = params['comment']
    #     rating = params['rating']
    #     db.execute('INSERT INTO bok_user (name, bok_id, comment, rating) VALUES (?,?,?,?)', name, bok_id, comment, rating)
    #     redirect "/bocker/index" 
    # end

    post  '/comments/new' do
        if session[:user_id] == nil
            redirect "/"
        end
        name = params['username']
        bok_id = params['bok_id']
        comment = params['comment']
        rating =params['rating']
        @Comment = Comment.create(name, bok_id, comment, rating)
        redirect "/bocker/index/#{bok_id}"
    end

end