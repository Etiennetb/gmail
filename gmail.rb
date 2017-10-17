require "pry"
require 'gmail'
require "dotenv"
Dotenv.load

class Email_sender

	def initialize
		@gmail = Gmail.connect(ENV["EMAIL"], ENV["PASSWORD"])
		binding.pry
	end


	def connect_to_gmail
		#@gmail = Gmail.connect(ENV["EMAIL"], ENV["PASSWORD"])  # autre technique : Gmail.connect(ENV["EMAIL"], ENV["PASSWORD"]) do |gmail|
		# play with your gmail...                             # se déconnecte après end   

		if @gmail.logged_in?
			puts "ok"
		else
			puts "not  ok"
		end
	end
	
	def email_count

		puts @gmail.inbox.count
		puts @gmail.inbox.count(:unread)
		puts @gmail.inbox.count(:read)
	end

	def perform
		connect_to_gmail
		email_count
		@gmail.logout
	end		
end

email_test = Email_sender.new
email_test.perform
