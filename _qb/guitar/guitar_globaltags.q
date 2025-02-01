script setup_globaltags 
	globaltag_checksum = initial_v43
	setup_songtags globaltag_checksum = <globaltag_checksum>
	setup_venuetags globaltag_checksum = <globaltag_checksum>
	setup_unlocks globaltag_checksum = <globaltag_checksum>
	get_progression_globals \{game_mode = p1_career}
	setup_setlisttags setlist_songs = <tier_global> globaltag_checksum = <globaltag_checksum>
	get_progression_globals \{game_mode = p2_career}
	setup_setlisttags setlist_songs = <tier_global> globaltag_checksum = <globaltag_checksum>
	get_progression_globals \{game_mode = p1_quickplay}
	setup_setlisttags setlist_songs = <tier_global> globaltag_checksum = <globaltag_checksum>
	get_progression_globals \{game_mode = p1_bass_quickplay}
	setup_setlisttags setlist_songs = <tier_global> globaltag_checksum = <globaltag_checksum>
	get_progression_globals \{game_mode = p2_faceoff}
	setup_setlisttags setlist_songs = <tier_global> globaltag_checksum = <globaltag_checksum>
	get_progression_globals \{game_mode = p1_quickplay
		bonus}
	setup_setlisttags setlist_songs = <tier_global> globaltag_checksum = <globaltag_checksum>
	get_progression_globals \{game_mode = p1_bass_quickplay
		bonus}
	setup_setlisttags setlist_songs = <tier_global> globaltag_checksum = <globaltag_checksum>
	get_progression_globals \{game_mode = p1_quickplay
		download}
	setup_setlisttags setlist_songs = <tier_global> globaltag_checksum = <globaltag_checksum>
	get_progression_globals \{game_mode = p1_bass_quickplay
		download}
	setup_setlisttags setlist_songs = <tier_global> globaltag_checksum = <globaltag_checksum>
	setup_bandtags globaltag_checksum = <globaltag_checksum>
	setup_user_option_tags globaltag_checksum = <globaltag_checksum>
	setup_training_tags globaltag_checksum = <globaltag_checksum>
	setup_store_tags globaltag_checksum = <globaltag_checksum>
	setup_characterguitar_tags globaltag_checksum = <globaltag_checksum>
	setup_online_tags globaltag_checksum = <globaltag_checksum>
	setup_character_tags globaltag_checksum = <globaltag_checksum>
	setup_achievement_tags globaltag_checksum = <globaltag_checksum>
	setglobaltags globaltag_checksum params = {globaltag_checksum = <globaltag_checksum>}
endscript

script setup_user_option_tags 
	SetGlobalTags \{user_options
		Params = {
			guitar_volume = 11
			band_volume = 11
			sfx_volume = 11
			lefty_flip_p1 = 0
			lefty_flip_p2 = 0
			lag_calibration = 0.0
			autosave = 1
			resting_whammy_position_device_0 = -0.76
			resting_whammy_position_device_1 = -0.76
			resting_whammy_position_device_2 = -0.76
			resting_whammy_position_device_3 = -0.76
			resting_whammy_position_device_4 = -0.76
			resting_whammy_position_device_5 = -0.76
			resting_whammy_position_device_6 = -0.76
			star_power_position_device_0 = -1.0
			star_power_position_device_1 = -1.0
			star_power_position_device_2 = -1.0
			star_power_position_device_3 = -1.0
			star_power_position_device_4 = -1.0
			star_power_position_device_5 = -1.0
			star_power_position_device_6 = -1.0
			gamma_brightness = 5
			online_game_mode = 0
			online_difficulty = 0
			online_num_songs = 0
			online_tie_breaker = 0
			online_highway = 0
			unlock_Cheat_AirGuitar = 0
			unlock_Cheat_PerformanceMode = 0
			unlock_Cheat_Hyperspeed = 0
			unlock_Cheat_NoFail = 0
			unlock_Cheat_EasyExpert = 0
			unlock_Cheat_PrecisionMode = 0
			unlock_Cheat_BretMichaels = 0
			unlock_Cheat_LargeGems = 0
			black_highway = 0
			black_background = 0
			transparent_highway = 0
			song_title = 0
			highway_shake = 0
			early_timing = 0
			no_flames = 0
			no_whammy_particles = 0
			no_whammy_pitch_shift = 0
			no_miss_sfx = 0
			select_restart = 0
			awesomeness = 0
			nopostproc = 0
			dx_large_gems = 0
			insta_fail = 0
		}}
endscript
