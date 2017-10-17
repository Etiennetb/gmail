require "pry"
require 'gmail'
require "dotenv"
Dotenv.load

class Email_sender

	def initialize
		@gmail = Gmail.connect(ENV["EMAIL"], ENV["PASSWORD"])
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

	def send_mail

		@destinataires = ["exemple@hotmail.fr", "exemple@gmail.com"]
		@destinataires.each do |destinataire|

			@gmail.deliver do
				to ("#{destinataire}")
				subject "Bonne ambiance dans les vestiaires"
			  text_part do
				body "J'ai trop la pêche! One, two, one, two!"
		      end
		      html_part do
		    	content_type 'text/html; charset=UTF-8'
		    	body "<p>Hello, ce petit mail vous a été envoyé depuis un programme de code.<br> 
		    	Je deviens fort (en pomme). On est fort... en pomme!<br>
		    	Bon courage pour cette semaine. La bise <br>
		    	Petit Bonus : J'ai trop la pêche! One, two, one, two!.</p><br>
		    	<a href = 'https://www.youtube.com/watch?v=pKIrZw3pkNM'>Salut c'est cool</a>"
		      end
		      #add_file "images/code.png"
		    end
		end
	end


	def perform
		connect_to_gmail
		send_mail
		# email_count
		@gmail.logout
	end		
end

email_test = Email_sender.new
email_test.perform
