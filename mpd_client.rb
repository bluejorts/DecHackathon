require 'ruby-mpd'

mpd = MPD.new 'polymetric.me', 6600

mpd.connect

status = mpd.status
puts status

queue = mpd.queue

queue.each do |song|
	if song==mpd.current_song
		puts "Current Song: #{song.artist} - #{song.title}"
	else
		puts "#{song.artist} - #{song.title}"
	end
end

mpd.disconnect