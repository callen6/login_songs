# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  password_digest :string(255)
#  password_salt   :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'bcrypt'

class User < ActiveRecord::Base
	include BCrypt

	attr_accessor :password

	# makes sure we don't store plain text passwords in our database
	# salt is a randomly generated string
	# combined with string password into a hash
	def encrypt_password
		if password.present?
			self.password_salt = BCrypt::Engine.generate_salt
			self.password_digest = BCrypt::Engine.hash_secret(password, self.password_salt)
		else
			nil
		end
	end

	# authenticate this user
	def authenticate(email, password)
		user = User.find_by_email(email)
		if user && user.password_digest == BCrypt::Engine.hash_secret(password, user.password_salt)
			user
		else
			nil
		end
	end

end