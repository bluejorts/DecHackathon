require 'ruby-mpd'
require 'thor'

@mpd = MPD.new 'polymetric.me', 6600

@mpd.connect

@status = @mpd.status

def queue()
	@mpd.queue.each do |song|
		if song==@mpd.current_song
			puts "Current Song: #{song.artist} - #{song.title}"
		else
			puts "#{song.artist} - #{song.title}"
		end
	end
end

def search(artist, title)
	puts @mpd.where(artist: '#{artist}',title: '#{title}')
	puts 'hello'
end

def play()
	@mpd.play
end

def pause()
	@mpd.stop
end

def next_song()
	@mpd.next
end

def previous_song()
	@mpd.previous
end

while true
	input = gets.chomp
	case input
		when 'queue'
			queue()
		when 'search'
			puts 'Artist?'
			artist = gets.chomp
			puts 'Title?'
			title = gets.chomp
			search(artist,title)
			puts 'hello'
		when 'play'
			play()
		when 'pause'
			pause()
		when 'next'
			next_song()
		when 'previous'
			previous_song()
		when 'exit'
			return true
		else
			puts 'Quit feeding me nonsense!'
	end
end

@mpd.disconnect