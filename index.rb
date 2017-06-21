# -*- coding: UTF-8 -*-
require 'telegram/bot'
require 'net/http'
require 'json'

# Token fornecido pelo BotFather
token = '374527114:AAH2irPyZF-FnfOWGorCoodW4kVJNFEFolY'

# Url do raspberry
url_cam = 'http://192.168.43.196:8080/RPi_Cam/cam.jpg'

# Url alocada a api
url_api = 'http://b5745128.ngrok.io/'

# Uri para requisitar a imagem
uri_create = URI(url_api + 'v1/api/image/create/')

# possiveis marcas de retorno no cloud vision
labels_drink = JSON.parse(File.read('db/labels-drink.json'))


#
# Verifica se existe cerveja ou marca
#
def make_text(labels_drink, vision)
	brand_avaliable = 0
	labels_avaliable = 0

	vision["web"].each do |entityWeb|
		labels_drink["brands"].each do |label|
			if entityWeb["description"].downcase.include?(label["name"].downcase)		
				brand_avaliable += 1
			end
		end
	end

	vision["web"].each do |labelVis|
		labels_drink["labels"].each do |label|
			if labelVis["description"].downcase.include?(label["name"].downcase)		
				labels_avaliable += 1
			end
		end
	end

	if brand_avaliable + labels_avaliable == 0
		"Não achamos \xF0\x9F\x8D\xBA ..."		
	else
		"Tem \xF0\x9F\x8D\xBA \n"
	end
end


Telegram::Bot::Client.run(token) do |bot|
  	bot.listen do |message|
		
		if message.text == "\xF0\x9F\x8D\xBA"
			
			res = JSON.parse(Net::HTTP.post_form(uri_create, 'urlImage' => url_cam).body)
			bot.api.send_message(chat_id: message.chat.id, text: "\xF0\x9F\x95\xA1")
			bot.api.sendPhoto(chat_id: message.chat.id, photo: url_api + res["pathFile"])
	     	bot.api.send_message(chat_id: message.chat.id, text: make_text(labels_drink, res["vision"]))

		elsif !message.text.to_s.empty?
			kb = [
			    Telegram::Bot::Types::KeyboardButton.new(text: "\xF0\x9F\x8D\xBA"),
			]
			markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb)
			bot.api.send_message(chat_id: message.chat.id, text: "Eai #{message.from.first_name} toque para saber se tem breja pra hoje...", reply_markup: markup)
		end
 	end
end
