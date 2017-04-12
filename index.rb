require 'telegram/bot'

token = ''
Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/tembreja'
      bot.api.send_message(chat_id: message.chat.id, text:"http://192.168.43.138:8080/RPi_Cam/cam.jpg")
    end
  end
end