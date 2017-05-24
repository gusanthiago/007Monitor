require 'telegram/bot'
require 'net/http'

token = '374527114:AAH2irPyZF-FnfOWGorCoodW4kVJNFEFolY'
# urlRaspberry = 'http://192.168.43.138:8080/RPi_Cam/cam.jpg'
urlTest = 'https://lh6.googleusercontent.com/-ztabNasVSSU/TWl43mOmsPI/AAAAAAAAAIA/_fKSb-CC9Ss/s400/030120091293.jpg' # em teste
uriApi = URI('http://localhost:3000/v1/api/image/create/')

# TODO fazer um autoload :|
Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
  	# TODO Melhorar interface das mensagens
    case message.text
    when '/disponivel'
        res = JSON.parse(Net::HTTP.post_form(uriApi, 'urlImage' => urlTest).body)
      	bot.api.send_message(chat_id: message.chat.id, text: res['urlOrigin'])
    end
  end
end
