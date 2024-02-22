require 'debug'
class App < Sinatra::Base

    def db
        if @db == nil
            @db = SQLite3::Database.new('Böcker')#Sätt in namnet på databasen
            @db.results_as_hash = true
        end
        return @db
    end
end


#Sida 1.0
    #Se info om sidan
    #Länka till inloggning

#Sida 1.1 Skapa konto 

#Sida 1.2 Logga in användare

#Sida 1.3 Logga in admin

#Sida 2.0 Alla böcker (tänk julkalendern)

get '/' do
    @result = db.execute('SELECT * FROM Böcker')
    erb :'views/index'
end

#Sida 2.1 Bok med titel, komentarer, rekomendation

#Sida 3.0 Profil inloggad användare

#Sida 3.1 Profil admin