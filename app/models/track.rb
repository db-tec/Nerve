require 'json'
require 'rubygems'
require 'yaml'
require 'pp'

module Nerve; module Model

	class Track

		attr_accessor :id, :external_id, :title, :artist, :album, :status
		attr_accessor :genre, :creation_date, :last_update, :local_kill_date
		attr_accessor :local_path, :intro_start, :intro_end, :hook_start, :hook_end, :outro
		attr_accessor :end_type, :waveform, :length, :bitrate, :sample_rate

		attr_accessor :is_library, :is_automation, :playout_id

		def self.all

			warn "Track.all is deprecated, use TrackProvider.all instead"
			TrackProvider.all

		end

		def self.from_id id 

			warn "Track.from_id is deprecated, use TrackProvider.from_id instead"
			TrackProvider.from_id id

		end

		def initialize result

			@id = result["id"]
			@external_id = result["external_id"]
			@title = result["title"]

			@artist = result["artist_name"]
			@album = result["album_name"]

			@genre = result["main_genre"]

			@length = result["length"]
			@status = result["status"]

			@upload_date = result["creation_date"]

			@approved_by = result["approved_by"]
			@last_update = result["last_update"]

			@local_path, @local_kill_date = result["local_path"], result["local_kill_date"]


			@intro_start = result["intro_start"].to_f  if result["intro_start"] != nil
			@intro_end   = result["intro_end"].to_f    if result["intro_end"] != nil
			@hook_start  = result["hook_start"].to_f   if result["hook_start"] != nil
			@hook_end    =  result["hook_end"].to_f    if result["hook_end"] != nil
			@outro       = result["outro"].to_f        if result["intro_start"] != nil

			@bitrate, @sample_rate = result["bitrate"], result["sample_rate"]

			@is_library = result["is_library"] == 1
			@is_automation = result["is_automation"] == 1

			@playout_id = result["playout_id"] or ''

			@explicit = result["explicit"] == 1

		end

		def approved
			@status > 3
		end

		def get_metadata

			result = Nerve::Services::Metadata.match_meta(@external_id, true, "external_id")
			big = result["big"]

			lyrics = JSON.parse(big["lyrics"])[0] rescue ""

			if !lyrics or lyrics.to_s.empty?
				lyrics = Nerve::Services::Metadata.match_lyrics(@artist, @album, @title)[0] \
					rescue "No lyrics available."
			end

			[result, lyrics, result["year"]]

		end

		# Unguaranteed to be absolutely safe, but it's more safe than sorry.
		def is_safe

			return false if @explicit or @status == 0
			extended, lyrics = get_metadata

			# This nasty looking regex basically matches all words that start with nasties. 
			# that way we don't match, say, saltwater (although we might actually want to, it's gross)
			r = Regexp.new("\\b((#{$config["words"]["banned"].join("|")})[^\\s\\b,.\<\>]*)\\b", 7)

			# If the size is 0, then it's "safe" ish
			return false if !lyrics or lyrics.to_s.empty?

			# TODO: make this cleaner
			lyrics.scan(r).size == 0 && !!lyrics && lyrics != ""

		end

		def why_unsafe

			return "determined as risky during upload" if @status == 0 # only works before submission
			return "has parental advisory/explicit flag" if @explicit
			extended, lyrics = get_metadata

			r = Regexp.new("\\b((#{$config["words"]["banned"].join("|")})[^\\s\\b,.\<\>]*)\\b", 7)
			s = lyrics.scan(r)

			return "it contains (at least one) expletive (#{s[0]})" if s.size > 0
			return "no lyrics were found" if !lyrics

			false

		end

		def save 

			Database.query("UPDATE tracks SET
				last_update=NOW(), title=?, intro_start=?, intro_end=?,
				hook_start=?, hook_end=?, outro=?, status=?,
				is_library = ?, is_automation = ?, playout_id = ?
				WHERE id=?", 
				@title, @intro_start, @intro_end,
				@hook_start, @hook_end, @outro, @status,
				@is_library ? 1 : 0, @is_automation ? 1 : 0, @playout_id,
				@id)

		end

		def created_by
			Nerve::Services::Login.get_service.get_user(@created_by) rescue nil
		end

		def approved_by
			Nerve::Services::Login.get_service.get_user(@created_by) rescue created_by
		end

		def to_json extended = false

			data = {
				"id" => @id,
				"external_id" => @external_id, 
				"title" => @title,
				"artist" => @artist,
				"album" => @album,
				"approved" => approved,
				"approved_by" => @approved_by,
				"genre" => @genre,
				"genre_text" => $genres[@genre],
				"length" => @length,
				"status" => @status,
				"upload_date" => @upload_date.iso8601,
				"is_library" => @is_library,
				"is_automation" => @is_automation,
				"playout_id" => @playout_id
			}

			# Extended means lyrics and such 
			if extended == true
				extended, lyrics = get_metadata
				data.merge!({
					"intro_start" => @intro_start,
					"intro_end" => @intro_end,
					"hook_start" => @hook_start,
					"hook_end" => @hook_end,
					"extro_start" => @outro	})
			else
				extended = false
			end
			
			data["big"] = extended
			data["lyrics"] = lyrics

			data.to_json

		end




	end

end; end