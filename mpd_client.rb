require 'mpd_client'
require 'em-websocket'
require 'lyricfy'

@mpd = MPDClient.new

@mpd.connect('polymetric.me', 6600)

@status = @mpd.status

def queue()
	@mpd.playlistinfo.each do |song|
		puts "#{song['artist']} - #{song['album']} - #{song['title']}"
	end
end

def lyrics()
    fetcher = Lyricfy::Fetcher.new
    song = @mpd.currentsong
    lyrics = fetcher.search song['artist'], song['title']
    puts lyrics.body
end

def play()
	@mpd.play
end

def pause()
	@mpd.pause
end

def next_song()
	@mpd.next
end

def previous_song()
	@mpd.previous
end

def seek()
	@mpd.seek()
end

puts "MPD version: #{@mpd.mpd_version}"
puts "mpd_client version: #{MPDClient::VERSION}"
	
EM.run {
  EM::WebSocket.run(:host => "0.0.0.0", :port => 1234) do |ws|
    ws.onopen { |handshake|
      puts "WebSocket connection open"

      # Access properties on the EM::WebSocket::Handshake object, e.g.
      # path, query_string, origin, headers

      # Publish message to the client
      ws.send "Hello Client, you connected to #{handshake.path}"
    }

    ws.onclose { puts "Connection closed" }

    ws.onmessage { |msg|
    	ws.send msg
		case msg
			when 'queue'
				ws.send queue()
			when 'search'
				ws.send 'Search for? [artist, album, title, tag, etc.]'
				string = gets.chomp
				songs = @mpd.search('any', string)
				songs.each do |song|
					ws.send "#{song['artist']} - #{song['album']} - #{song['title']}"
				end
            when 'lyrics'
                ws.send lyrics()
			when 'play'
				play()
			when 'pause'
				pause()
			when 'next'
				next_song()
			when 'previous'
				previous_song()
            when 'current'
                song = @mpd.currentsong
                ws.send "#{song['artist']} - #{song['album']} - #{song['title']}"
            else
				ws.send 'Quit feeding me nonsense!'
		end
    }
  end
}
