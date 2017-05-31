require 'telegram/bot'
require 'net/http'

token = '374527114:AAH2irPyZF-FnfOWGorCoodW4kVJNFEFolY'
# urlRaspberry = 'http://192.168.43.138:8080/RPi_Cam/cam.jpg'
urlTest = 'https://lh6.googleusercontent.com/-ztabNasVSSU/TWl43mOmsPI/AAAAAAAAAIA/_fKSb-CC9Ss/s400/030120091293.jpg' # em teste
urlServer = 'http://localhost:3000'
urlApi = '/v1/api/'
urlCreate = URI(urlServer + urlApi + 'image/create/')
# TODO fazer um autoload :|
Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
  	# TODO Melhorar interface das mensagens
    case message.text
    when '/disponivel'
        res = JSON.parse(Net::HTTP.post_form(urlCreate, 'urlImage' => urlTest).body)
      	bot.api.sendPhoto(chat_id: message.chat.id, photo: 'http://localhost:3000/images_request/240343359710988295606533978191045067684JPEDUQGB.jpg' )
    end
  end
end
