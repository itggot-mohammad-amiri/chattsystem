class App < Sinatra::Base

	enable :sessions

	def set_error(error_message)
		session[:error] = error_message
	end

	def get_error()
		error = session[:error]
		session[:error] = nil
		return error
	end

	get('/') do
		slim(:index)
	end

	get('/register') do
		slim(:register)
	end

	get('/error') do
		slim(:error)
	end

	get('/notes/create') do
		slim(:create_note)
	end

	get '/home' do
		slim :home
	end

	post('/register') do
		db = SQLite3::Database.new('db/Chatsystem.db')
		db.results_as_hash = true
		
		username = params["username"]
		email = params["email"]
		password = params["password"]
		password_confirmation = params["confirm_password"]
		
		result = db.execute("SELECT id FROM users WHERE username=?", [username])
		
		if result.empty?
			if password == password_confirmation
				password_digest = BCrypt::Password.create(password)
				
				db.execute("INSERT INTO Users(username, password_digest, email) VALUES (?,?,?)", [username, password_digest,email])
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
	
	
	post('/login') do
		db = SQLite3::Database.new('db/Chatsystem.db')
		db.results_as_hash = true
		username = params["username"]
		password = params["password"]
		
		result = db.execute("SELECT id, password_digest FROM Users WHERE username=?", [username])

		if result.empty?
			set_error("Invalid Credentials")
			redirect('/error')
		end

		user_id = result.first["id"]
		password_digest = result.first["password_digest"]
		if BCrypt::Password.new(password_digest) == password
			session[:user_id] = user_id
			redirect('/home')
		else
			set_error("Invalid Credentials")
			redirect('/error')
		end
	end

	post('/logout') do
		session.destroy
		redirect('/')
	end
 end
