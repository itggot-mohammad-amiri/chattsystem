class App < Sinatra::Base
	enable :session 

	# def set_error(error_message)
	# 	session[:error] =error_message		
	# end

	# def get_error()
	# 	error = session[:error]
	# 	session[:error] = nil
	# 	return error
	# end

	get '/' do
		slim(:index)
	end

	get '/register' do
		slim :register 
	end

	post 'register' do 
		db.SQlite3::Datebase.new('db/Chatsystem.sqlite')
		db.results_as_hash = true

		username = params["username"]
		email=params["email"]
		password = params["password"]
		password_confirmation = ["confirm_password"]
		
		db.execute("INSERT INTO Users(momo) VALUES (?)", [username])

		result = db.execute("SELECT id FROM Users WHERE username=?", [Username] )
		
		if result.empty?
			if password == password_confirmation
				password_digest = BCrypt::Password.create(password)
				
				db.execute("INSERT INTO Users(1,username,email, password_digest) VALUES (?,?,?,?)", [id,username, email, password_digest])
				redirect('/')
			else
				set_error("Passwords don't match")
				redirect('/error')
			end
		else
			set_error("Username already exists")
			redirect('/error')
		end
		 
	end 

end           
