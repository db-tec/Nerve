module Nerve; module Model

	class TrackProvider

		def self.from_id id

			result = where("t.id = ?", id).first

			raise "No such track" if !result
			result

		end

		def self.all

			where("")

		end

		def self.where where, *params

			result = Database.query("SELECT t.*, a.name AS album_name, r.name AS artist_name,
				CAST(length AS CHAR(255)) AS length
				FROM `tracks` t
				LEFT JOIN `albums` a ON a.id = t.album 
				LEFT JOIN `artists` r ON r.id = t.artist 
				WHERE #{where};", *params).to_a.map { | a | self.from a }

		end

		private
		def self.from result
			Track.new result
		end

	end

end; end