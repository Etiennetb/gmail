require "pry"
require 'gmail'
require "dotenv"
require "rubygems"
require "nokogiri"
require "open-uri"
require "google_drive"
Dotenv.load

class Town_scraping
	     

	def get_the_townhall_name
		
		$city_name = []
		@city_array = []
		# OUVERTURE DE LA PAGE AVEC NOKOGIRI

		@urlfinistere = ["http://annuaire-des-mairies.com/finistere.html", "http://annuaire-des-mairies.com/finistere-2.html"]
		@urlfinistere.each do |page|

			landing_page = Nokogiri::HTML(open("#{page}"))
		    
		    # DEFINITION DU TABLEAU DES VILLES ET DU TABLEAU DES URL

		    city_links = landing_page.css("a[class=lientxt]")
		    city_links.each do |link|  
		    $city_name << link['href'].sub!("./29/", "").sub!(".html", "").capitalize
		    @city_array << link['href'].sub!(".", "http://annuaire-des-mairies.com")
			end
		end
	end


	def get_the_email_of_a_townhall_from_its_webpage
	    
	    # OUVERTURE PROGRESSIVE DE CHAQUE URL ET DEFINITION DU TABLEAU DE MAILS	
		$townhall_mail =[]

		@city_array.each do |url|
			sleep(rand(0.1..0.5))
		page = Nokogiri::HTML(open("#{url}"))

			mail_element = page.css('p:contains("@")')
		    mail = mail_element.text
	        mail = "Unavailable"  if mail.empty?
		   
		   $townhall_mail << mail
		    	 
		end
	end

	 
	def make_hash
		$annuaire_29 = {}
		i = 0
	   $city_name.each do |key|
	     $annuaire_29["#{key}"]= $townhall_mail[i]
	     i += 1
	   end

		puts $annuaire_29
	end


	def perform

	    get_the_townhall_name
		get_the_email_of_a_townhall_from_its_webpage
		make_hash
	end
end

city_scraping = Town_scraping.new
city_scraping.perform


class Convert

	def convert_googlesheet

		session = GoogleDrive::Session.from_service_account_key("client_secret.json")
	 
		# Get the spreadsheet by its title
		spreadsheet = session.spreadsheet_by_title("Annuaire_mairies")
		worksheet = spreadsheet.worksheets.first
		worksheet

		i = 2
		$city_name.each do |names|
			worksheet[i, 3] = "#{names}"
		i+= 1
		end

		i = 2
		$townhall_mail.each do |mail|
			worksheet[i, 4] = "#{mail}"
		i+= 1
		end
		
		worksheet.save
	end
		
	def perform_conversion

	    convert_googlesheet
	end	
end
convert_files = Convert.new
convert_files.perform_conversion

