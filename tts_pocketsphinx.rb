require 'pocketsphinx-ruby'

configuration = Pocketsphinx::Configuration::KeywordSpotting.new('Okay computer')
recognizer = Pocketsphinx::LiveSpeechRecognizer.new(configuration)
recognizer.recognize do |speech|
	puts speech
end