dx_menu_autosave_fs = {
	Create = dx_memcard_sequence_begin_autosave
	Destroy = memcard_sequence_cleanup_generic
	actions = [
		{
			action = memcard_sequence_save_success
			flow_state = main_menu_fs
			transition_left
		}
		{
			action = memcard_sequence_save_failed
			flow_state = main_menu_fs
			transition_left
		}
	]
}

main_menu_fs = {
	Create = create_main_menu
	Destroy = destroy_main_menu
	actions = [
		{
			action = select_career
			flow_state_func = main_menu_career_flow_state_func
			transition_right
		}
		{
			action = select_coop_career
			flow_state = coop_career_select_controllers_fs
			transition_right
		}
		{
			action = select_quickplay
			flow_state = quickplay_select_difficulty_fs
			transition_right
		}
		{
			action = select_multiplayer
			flow_state = mp_select_controller_fs
			transition_right
		}
		{
			action = select_xbox_live
			flow_state = online_signin_fs
		}
		{
			action = select_options
			flow_state = options_select_option_fs
			transition_right
		}
		{
			action = select_training
			flow_state = practice_select_mode_fs
			transition_right
		}
		{
			action = select_debug_menu
			flow_state = debug_menu_fs
		}
		{
			action = select_custom_menu
			flow_state = custom_menu_fs
			transition_right
		}
		{
			action = online_enabled
			flow_state_func = 0xf6ee2c5e
		}
		{
			action = 0x653f903a
			flow_state = enter_profile_name_fs
		}
		{
			action = enter_attract_mode
			flow_state = 0xea90f674
		}
	]
}

script load_dx_settings
	GetGlobalTags \{user_options}
	if (<black_highway> = 1)
		Change highway_normal = $highway_black
		Change highway_starpower = $highway_black
	endif
	if (<transparent_highway> = 1)
		Change highway_normal = $highway_transparent
		Change highway_starpower = $highway_transparent
	endif
	GetGlobalTags $0xaebf2394 noassert = 1
	if (<ondisp_dispfps_text> = 1)
		enable_dispfps
	endif
endscript

script create_main_menu 
	load_dx_settings
	set_home_button_allowed
	GetGlobalTags \{user_options}
	menu_audio_settings_update_guitar_volume vol = <guitar_volume>
	menu_audio_settings_update_band_volume vol = <band_volume>
	menu_audio_settings_update_sfx_volume vol = <sfx_volume>
	SetSoundBussParams {Crowd = {vol = ($Default_BussSet.Crowd.vol)}}

	if ($main_menu_movie_first_time = 0)
		FadeToBlack \{ON
			Time = 0
			Alpha = 1.0
			z_priority = 900}
	endif
	create_main_menu_backdrop
	if ($main_menu_movie_first_time = 0 && $invite_controller = -1)
		PlayMovieAndWait \{movie = 'gh3_intro'
			noblack
			noletterbox}
		Change \{main_menu_movie_first_time = 1}
		FadeToBlack \{OFF
			Time = 0}
	endif
	

	SetMenuAutoRepeatTimes \{(0.3, 0.05)}
	kill_start_key_binding
	UnPauseGame
	Change \{check_for_unplugged_controllers = 1}
	Change \{current_num_players = 1}
	Change StructureName = player1_status controller = ($primary_controller)
	Change \{player_controls_valid = 0}
	disable_pause
	SpawnScriptNow \{Menu_Music_On
		Params = {
			setflag = 1
		}}
	0xe5282627
	if ($is_demo_mode = 1 || IsWinPort)
		demo_mode_disable = {rgba = [128 128 128 255] NOT_FOCUSABLE}
	else
		demo_mode_disable = {}
	endif
	DeRegisterAtoms
	RegisterAtoms \{Name = Achievement
		$Achievement_Atoms}
	Change \{setlist_previous_tier = 1}
	Change \{setlist_previous_song = 0}
	Change \{setlist_previous_tab = tab_setlist}
	Change \{current_song = welcometothejungle}
	Change \{end_credits = 0}
	Change \{battle_sudden_death = 0}
	Change \{StructureName = player1_status
		character_id = Axel}
	Change \{StructureName = player2_status
		character_id = Axel}
	Change \{default_menu_focus_color = [
			125
			0
			0
			255
		]}
	Change \{default_menu_unfocus_color = $menu_text_color}
	safe_create_gh3_pause_menu
	base_menu_pos = (730.0, 90.0)
	main_menu_font = fontgrid_title_gh3
	new_menu scrollid = main_menu_scrolling_menu vmenuid = vmenu_main_menu use_backdrop = (0) Menu_pos = (<base_menu_pos>)
	Change \{rich_presence_context = presence_main_menu}

	if ((IsNGC) || (IsPS2))
		career_text_off = (-30.0, 0.0)
		career_text_scale = (2.0667, 1.9333)
		coop_career_text_off = (<career_text_off> + (30.0, 75.0))
		coop_career_text_scale = (1.0667, 1.2)
		quickplay_text_off = (<coop_career_text_off> + (-35.0, 30.0))
		quickplay_text_scale = (2.2, 2.0667)
		multiplayer_text_off = (<quickplay_text_off> + (-40.0, 78.0))
		multiplayer_text_scale = (1.6, 1.4667)
		training_text_off = (<multiplayer_text_off> + (60.0, 42.0))
		training_text_scale = (2.0, 2.0)
		custom_menu_text_off = (<training_text_off> + (-60.0, 77.0))
		custom_menu_text_scale = (1.4667, 1.333)
		options_text_off = (<custom_menu_text_off> + (20.0, 48.0))
		options_text_scale = (1.6, 1.4667)
		leaderboards_text_off = (<options_text_off> + (25.0, 55.0))
		leaderboards_text_scale = (1.4667, 1.333)
		debug_menu_text_off = (<leaderboards_text_off> + (-30.0, 160.0))
		debug_menu_text_scale = 1.0667
	else
		career_text_off = (-30.0, 0.0)
		career_text_scale = (1.55, 1.4499999)
		coop_career_text_off = (<career_text_off> + (30.0, 63.0))
		coop_career_text_scale = (0.8, 0.9)
		quickplay_text_off = (<coop_career_text_off> + (-35.0, 40.0))
		quickplay_text_scale = (1.65, 1.55)
		multiplayer_text_off = (<quickplay_text_off> + (-40.0, 65.0))
		multiplayer_text_scale = (1.2, 1.1)
		training_text_off = (<multiplayer_text_off> + (60.0, 47.0))
		training_text_scale = (1.5, 1.5)
		custom_menu_text_off = (<training_text_off> + (-60.0, 63.0))
		custom_menu_text_scale = (1.1, 1.0)
		options_text_off = (<custom_menu_text_off> + (20.0, 45.0))
		options_text_scale = (1.2, 1.1)
		leaderboards_text_off = (<options_text_off> + (20.0, 48.0))
		leaderboards_text_scale = (1.1, 1.0)
		debug_menu_text_off = (<leaderboards_text_off> + (-30.0, 160.0))
		debug_menu_text_scale = 0.8
	endif

	CreateScreenElement {
		Type = TextElement
		Id = main_menu_career_text
		PARENT = main_menu_text_container
		Text = 'CAREER'
		font = <main_menu_font>
		Pos = {(<career_text_off>) Relative}
		Scale = (<career_text_scale>)
		rgba = ($menu_text_color)
		just = [LEFT Top]
		font_spacing = 0
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba = [0 0 0 255]
		z_priority = 60
	}
	GetScreenElementDims Id = <Id>
	if (<width> > 420)
		SetScreenElementProps Id = <Id> Scale = 1
		fit_text_in_rectangle Id = <Id> Dims = ((420.0, 0.0) + <Height> * (0.0, 1.0))
	endif
	CreateScreenElement {
		Type = TextElement
		Id = main_menu_coop_career_text
		PARENT = main_menu_text_container
		Text = 'CO-OP CAREER'
		font = <main_menu_font>
		Pos = {(<coop_career_text_off>) Relative}
		Scale = (<coop_career_text_scale>)
		rgba = ($menu_text_color)
		just = [LEFT Top]
		font_spacing = 0
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba = [0 0 0 255]
		z_priority = 60
	}
	GetScreenElementDims Id = <Id>
	if (<width> > 400)
		SetScreenElementProps Id = <Id> Scale = 1
		fit_text_in_rectangle Id = <Id> Dims = ((400.0, 0.0) + <Height> * (0.0, 1.0))
	endif
	CreateScreenElement {
		Type = TextElement
		Id = main_menu_quickplay_text
		PARENT = main_menu_text_container
		font = <main_menu_font>
		Text = 'QUICKPLAY'
		font_spacing = 0
		Pos = {(<quickplay_text_off>) Relative}
		Scale = (<quickplay_text_scale>)
		rgba = ($menu_text_color)
		just = [LEFT Top]
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba = [0 0 0 255]
		z_priority = 60
	}
	GetScreenElementDims Id = <Id>
	if (<width> > 400)
		SetScreenElementProps Id = <Id> Scale = 1
		fit_text_in_rectangle Id = <Id> Dims = ((400.0, 0.0) + <Height> * (0.0, 1.0))
	endif
	CreateScreenElement {
		Type = TextElement
		Id = main_menu_multiplayer_text
		PARENT = main_menu_text_container
		font = <main_menu_font>
		Text = 'MULTIPLAYER'
		font_spacing = 1
		Pos = {(<multiplayer_text_off>) Relative}
		Scale = (<multiplayer_text_scale>)
		rgba = ($menu_text_color)
		just = [LEFT Top]
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba = [0 0 0 255]
		z_priority = 60
	}
	GetScreenElementDims Id = <Id>
	if (<width> > 460)
		SetScreenElementProps Id = <Id> Scale = 1
		fit_text_in_rectangle Id = <Id> Dims = ((460.0, 0.0) + <Height> * (0.0, 1.0))
	endif
	CreateScreenElement {
		Type = TextElement
		Id = main_menu_training_text
		PARENT = main_menu_text_container
		font = <main_menu_font>
		Text = 'TRAINING'
		font_spacing = 0
		Pos = {(<training_text_off>) Relative}
		Scale = (<training_text_scale>)
		rgba = ($menu_text_color)
		just = [LEFT Top]
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba = [0 0 0 255]
		z_priority = 60
	}
	GetScreenElementDims Id = <Id>
	if (<width> > 345)
		SetScreenElementProps Id = <Id> Scale = 1
		fit_text_in_rectangle Id = <Id> Dims = ((345.0, 0.0) + <Height> * (0.0, 1.0))
	endif
	GetScreenElementDims \{Id = main_menu_training_text}
	old_height = <Height>
	fit_text_in_rectangle Id = main_menu_training_text Dims = (350.0, 100.0) Pos = {(<training_text_off>) Relative} start_x_scale = (<training_text_scale>.(1.0, 0.0)) start_y_scale = (<training_text_scale>.(0.0, 1.0)) only_if_larger_x = 1 keep_ar = 1
	GetScreenElementDims \{Id = main_menu_training_text}
	Offset = ((<old_height> * ((<old_height> -24.0) / <old_height>)) - (<Height> * ((<Height> - (24.0 * ((1.0 * <Height>) / <old_height>))) / <Height>)))
	leaderboards_text_off = (<leaderboards_text_off> - <Offset> * (0.0, 1.0))
	options_text_off = (<options_text_off> - <Offset> * (0.0, 1.0))
	if IsXENON
		CreateScreenElement {
			Type = TextElement
			Id = main_menu_leaderboards_text
			PARENT = main_menu_text_container
			font = <main_menu_font>
			Text = 'XBOX LIVE'
			font_spacing = 0
			Pos = {(<leaderboards_text_off>) Relative}
			Scale = (<leaderboards_text_scale>)
			rgba = ($menu_text_color)
			just = [LEFT Top]
			Shadow
			shadow_offs = (3.0, 3.0)
			shadow_rgba = [0 0 0 255]
			z_priority = 60
			<demo_mode_disable>
		}
		GetScreenElementDims Id = <Id>
		if (<width> > 360)
			SetScreenElementProps Id = <Id> Scale = 1
			fit_text_in_rectangle Id = <Id> Dims = ((360.0, 0.0) + <Height> * (0.0, 1.0))
		endif
	elseif ISPS3
		CreateScreenElement {
			Type = TextElement
			Id = main_menu_leaderboards_text
			PARENT = main_menu_text_container
			font = <main_menu_font>
			Text = 'ONLINE'
			font_spacing = 0
			Pos = {(<leaderboards_text_off>) Relative}
			Scale = (<leaderboards_text_scale>)
			rgba = ($menu_text_color)
			just = [LEFT Top]
			Shadow
			shadow_offs = (3.0, 3.0)
			shadow_rgba = [0 0 0 255]
			z_priority = 60
		}
		GetScreenElementDims Id = <Id>
		if (<width> > 360)
			SetScreenElementProps Id = <Id> Scale = 1
			fit_text_in_rectangle Id = <Id> Dims = ((360.0, 0.0) + <Height> * (0.0, 1.0))
		endif
	elseif IsNGC
		CreateScreenElement {
			Type = TextElement
			Id = main_menu_leaderboards_text
			PARENT = main_menu_text_container
			font = <main_menu_font>
			Text = $wii_wifi
			font_spacing = 4
			Pos = {(<leaderboards_text_off>) Relative}
			Scale = (<leaderboards_text_scale>)
			rgba = ($menu_text_color)
			just = [LEFT Top]
			Shadow
			shadow_offs = (3.0, 3.0)
			shadow_rgba = [0 0 0 255]
			z_priority = 60
		}
		GetScreenElementDims Id = <Id>
		if (<width> > 360)
			SetScreenElementProps Id = <Id> Scale = 1
			fit_text_in_rectangle Id = <Id> Dims = ((360.0, 0.0) + <Height> * (0.0, 1.0))
		endif
	endif
	CreateScreenElement {
		Type = TextElement
		Id = main_menu_custom_menu_text
		PARENT = main_menu_text_container
		font = <main_menu_font>
		Text = 'DELUXE SETTINGS'
		font_spacing = 0
		Pos = {(<custom_menu_text_off>) Relative}
		Scale = (<custom_menu_text_scale>)
		rgba = ($menu_text_color)
		just = [LEFT Top]
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba = [0 0 0 255]
		z_priority = 60
	}
	GetScreenElementDims Id = <Id>
	if (<width> > 420)
		SetScreenElementProps Id = <Id> Scale = 1
		fit_text_in_rectangle Id = <Id> Dims = ((420.0, 0.0) + <Height> * (0.0, 1.0))
	endif
	CreateScreenElement {
		Type = TextElement
		Id = main_menu_options_text
		PARENT = main_menu_text_container
		font = <main_menu_font>
		Text = 'OPTIONS'
		font_spacing = 0
		Pos = {(<options_text_off>) Relative}
		Scale = (<options_text_scale>)
		rgba = ($menu_text_color)
		just = [LEFT Top]
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba = [0 0 0 255]
		z_priority = 60
	}
	GetScreenElementDims Id = <Id>
	if (<width> > 420)
		SetScreenElementProps Id = <Id> Scale = 1
		fit_text_in_rectangle Id = <Id> Dims = ((420.0, 0.0) + <Height> * (0.0, 1.0))
	endif
	if ($enable_button_cheats = 1)
		CreateScreenElement {
			Type = TextElement
			Id = main_menu_debug_menu_text
			PARENT = main_menu_text_container
			font = <main_menu_font>
			Text = 'DEBUG MENU'
			Pos = {(<debug_menu_text_off>) Relative}
			Scale = (<debug_menu_text_scale>)
			rgba = ($menu_text_color)
			just = [LEFT Top]
			Shadow
			shadow_offs = (3.0, 3.0)
			shadow_rgba = [0 0 0 255]
			z_priority = 60
		}
	endif
	offwhite = [255 255 205 255]
	hilite_off = (5.0, 0.0)
	if ((IsNGC) || (IsPS2))
		gm_hlInfoList = [
			{
				posL = (<career_text_off> + <hilite_off> + (-37.0, 16.0))
				posR = (<career_text_off> + <hilite_off> + (235.0, 16.0))
				beDims = (40.0, 40.0)
				posH = (<career_text_off> + <hilite_off> + (-14.0, 25.0))
				hDims = (248.0, 59.0)
			} ,
			{
				posL = (<coop_career_text_off> + <hilite_off> + (-33.0, 2.0))
				posR = (<coop_career_text_off> + <hilite_off> + (321.0, 2.0))
				beDims = (32.0, 32.0)
				posH = (<coop_career_text_off> + <hilite_off> + (-16.0, 14.0))
				hDims = (335.0, 37.0)
			} ,
			{
				posL = (<quickplay_text_off> + <hilite_off> + (-37.0, 6.0))
				posR = (<quickplay_text_off> + <hilite_off> + (284.0, 6.0))
				beDims = (40.0, 40.0)
				posH = (<quickplay_text_off> + <hilite_off> + (-16.0, 27.0))
				hDims = (295.0, 49.0)
			} ,
			{
				posL = (<multiplayer_text_off> + <hilite_off> + (-37.0, 6.0))
				posR = (<multiplayer_text_off> + <hilite_off> + (317.0, 6.0))
				beDims = (38.0, 38.0)
				posH = (<multiplayer_text_off> + <hilite_off> + (-18.0, 18.0))
				hDims = (330.0, 46.0)
			} ,
			{
				posL = (<training_text_off> + <hilite_off> + (-39.0, 17.0))
				posR = (<training_text_off> + <hilite_off> + (313.0, 16.0))
				beDims = (42.0, 42.0)
				posH = (<training_text_off> + <hilite_off> + (-17.0, 26.0))
				hDims = (328.0, 61.0)
			} ,
			{
				posL = (<leaderboards_text_off> + <hilite_off> + (-33.0, 3.0) + (0.0, 19.0))
				posR = (<leaderboards_text_off> + <hilite_off> + (148.0, 3.0) + (0.0, 19.0))
				beDims = (34.0, 34.0)
				posH = (<leaderboards_text_off> + <hilite_off> + (-13.0, -1.0) + (0.0, 16.0))
				hDims = (330.0, 46.0)
			} ,
			{
				posL = (<custom_menu_text_off> + <hilite_off> + (-36.0, 7.0))
				posR = (<custom_menu_text_off> + <hilite_off> + (204.0, 7.0))
				beDims = (36.0, 36.0)
				posH = (<custom_menu_text_off> + <hilite_off> + (-16.0, 19.0))
				hDims = (220.0, 45.0)
			} ,
			{
				posL = (<options_text_off> + <hilite_off> + (-36.0, 7.0))
				posR = (<options_text_off> + <hilite_off> + (204.0, 7.0))
				beDims = (36.0, 36.0)
				posH = (<options_text_off> + <hilite_off> + (-16.0, 19.0))
				hDims = (220.0, 45.0)
			} 
		]
	else
		gm_hlInfoList = [
			{
				posL = (<career_text_off> + <hilite_off> + (-40.0, 9.0))
				posR = (<career_text_off> + <hilite_off> + (218.0, 9.0))
				beDims = (40.0, 40.0)
				posH = (<career_text_off> + <hilite_off> + (-14.0, -2.0))
				hDims = (240.0, 57.0)
			} ,
			{
				posL = (<coop_career_text_off> + <hilite_off> + (-33.0, 3.0))
				posR = (<coop_career_text_off> + <hilite_off> + (281.0, 3.0))
				beDims = (32.0, 32.0)
				posH = (<coop_career_text_off> + <hilite_off> + (-14.0, -1.0))
				hDims = (300.0, 37.0)
			} ,
			{
				posL = (<quickplay_text_off> + <hilite_off> + (-34.0, 4.0))
				posR = (<quickplay_text_off> + <hilite_off> + (251.0, 4.0))
				beDims = (40.0, 40.0)
				posH = (<quickplay_text_off> + <hilite_off> + (-14.0, -2.0))
				hDims = (267.0, 47.0)
			} ,
			{
				posL = (<multiplayer_text_off> + <hilite_off> + (-37.0, 4.0))
				posR = (<multiplayer_text_off> + <hilite_off> + (301.0, 4.0))
				beDims = (38.0, 38.0)
				posH = (<multiplayer_text_off> + <hilite_off> + (-14.0, -1.0))
				hDims = (320.0, 43.0)
			} ,
			{
				posL = (<training_text_off> + <hilite_off> + (-31.0, 9.0))
				posR = (<training_text_off> + <hilite_off> + (282.0, 9.0))
				beDims = (42.0, 42.0)
				posH = (<training_text_off> + <hilite_off> + (-13.0, -2.0))
				hDims = (295.0, 61.0)
			} ,
			{
				posL = (<leaderboards_text_off> + <hilite_off> + (-33.0, 3.0))
				posR = (<leaderboards_text_off> + <hilite_off> + (213.0, 3.0))
				beDims = (34.0, 34.0)
				posH = (<leaderboards_text_off> + <hilite_off> + (-13.0, -2.0))
				hDims = (232.0, 40.0)
			} ,
			{
				posL = (<custom_menu_text_off> + <hilite_off> + (-36.0, 5.0))
				posR = (<custom_menu_text_off> + <hilite_off> + (183.0, 5.0))
				beDims = (36.0, 36.0)
				posH = (<custom_menu_text_off> + <hilite_off> + (-14.0, 0.0))
				hDims = (205.0, 43.0)
			} ,
			{
				posL = (<options_text_off> + <hilite_off> + (-36.0, 5.0))
				posR = (<options_text_off> + <hilite_off> + (183.0, 5.0))
				beDims = (36.0, 36.0)
				posH = (<options_text_off> + <hilite_off> + (-14.0, 0.0))
				hDims = (205.0, 43.0)
			}
		]
	endif
	<gm_hlIndex> = 0
	displaySprite {
		PARENT = main_menu_text_container
		tex = character_hub_hilite_bookend
		Pos = ((<gm_hlInfoList> [<gm_hlIndex>]).posL)
		Dims = ((<gm_hlInfoList> [<gm_hlIndex>]).beDims)
		rgba = <offwhite>
		Z = 2
	}
	<bookEnd1ID> = <Id>
	displaySprite {
		PARENT = main_menu_text_container
		tex = character_hub_hilite_bookend
		Pos = ((<gm_hlInfoList> [<gm_hlIndex>]).posR)
		Dims = ((<gm_hlInfoList> [<gm_hlIndex>]).beDims)
		rgba = <offwhite>
		Z = 2
	}
	<bookEnd2ID> = <Id>
	displaySprite {
		PARENT = main_menu_text_container
		Id = 0x3e2831d3
		tex = White
		rgba = <offwhite>
		Pos = ((<gm_hlInfoList> [<gm_hlIndex>]).posH)
		Dims = ((<gm_hlInfoList> [<gm_hlIndex>]).hDims)
		Z = 2
	}
	<whiteTexHighlightID> = <Id>
	CreateScreenElement {
		Type = TextElement
		PARENT = vmenu_main_menu
		font = <main_menu_font>
		Text = ''
		event_handlers = [
			{Focus retail_menu_focus Params = {Id = main_menu_career_text}}
			{Focus SetScreenElementProps Params = {Id = main_menu_career_text no_shadow}}
			{Focus guitar_menu_highlighter Params = {
					hlIndex = 0
					hlInfoList = <gm_hlInfoList>
					be1ID = <bookEnd1ID>
					be2ID = <bookEnd2ID>
					wthlID = <whiteTexHighlightID>
					text_id = main_menu_career_text
				}
			}
			{unfocus SetScreenElementProps Params = {Id = main_menu_career_text Shadow shadow_offs = (3.0, 3.0) shadow_rgba = [0 0 0 255]}}
			{unfocus retail_menu_unfocus Params = {Id = main_menu_career_text}}
			{pad_choose main_menu_select_career}
		]
		z_priority = -1
	}
	CreateScreenElement {
		Type = TextElement
		PARENT = vmenu_main_menu
		font = <main_menu_font>
		Text = ''
		event_handlers = [
			{Focus retail_menu_focus Params = {Id = main_menu_coop_career_text}}
			{Focus SetScreenElementProps Params = {Id = main_menu_coop_career_text no_shadow}}
			{Focus guitar_menu_highlighter Params = {
					hlIndex = 1
					hlInfoList = <gm_hlInfoList>
					be1ID = <bookEnd1ID>
					be2ID = <bookEnd2ID>
					wthlID = <whiteTexHighlightID>
					text_id = main_menu_coop_career_text
				}
			}
			{unfocus SetScreenElementProps Params = {Id = main_menu_coop_career_text Shadow shadow_offs = (3.0, 3.0) shadow_rgba = [0 0 0 255]}}
			{unfocus retail_menu_unfocus Params = {Id = main_menu_coop_career_text}}
			{pad_choose main_menu_select_coop_career}
		]
		z_priority = -1
	}
	CreateScreenElement {
		Type = TextElement
		PARENT = vmenu_main_menu
		font = <main_menu_font>
		Text = ''
		event_handlers = [
			{Focus retail_menu_focus Params = {Id = main_menu_quickplay_text}}
			{Focus SetScreenElementProps Params = {Id = main_menu_quickplay_text no_shadow}}
			{Focus guitar_menu_highlighter Params = {
					hlIndex = 2
					hlInfoList = <gm_hlInfoList>
					be1ID = <bookEnd1ID>
					be2ID = <bookEnd2ID>
					wthlID = <whiteTexHighlightID>
					text_id = main_menu_quickplay_text
				}
			}
			{unfocus SetScreenElementProps Params = {Id = main_menu_quickplay_text Shadow shadow_offs = (3.0, 3.0) shadow_rgba = [0 0 0 255]}}
			{unfocus retail_menu_unfocus Params = {Id = main_menu_quickplay_text}}
			{pad_choose main_menu_select_quickplay}
		]
		z_priority = -1
	}
	CreateScreenElement {
		Type = TextElement
		PARENT = vmenu_main_menu
		font = <main_menu_font>
		Text = ''
		event_handlers = [
			{Focus retail_menu_focus Params = {Id = main_menu_multiplayer_text}}
			{Focus SetScreenElementProps Params = {Id = main_menu_multiplayer_text no_shadow}}
			{Focus guitar_menu_highlighter Params = {
					hlIndex = 3
					hlInfoList = <gm_hlInfoList>
					be1ID = <bookEnd1ID>
					be2ID = <bookEnd2ID>
					wthlID = <whiteTexHighlightID>
					text_id = main_menu_multiplayer_text
				}
			}
			{unfocus SetScreenElementProps Params = {Id = main_menu_multiplayer_text Shadow shadow_offs = (3.0, 3.0) shadow_rgba = [0 0 0 255]}}
			{unfocus retail_menu_unfocus Params = {Id = main_menu_multiplayer_text}}
			{pad_choose main_menu_select_multiplayer}
		]
		z_priority = -1
	}
	CreateScreenElement {
		Type = TextElement
		PARENT = vmenu_main_menu
		font = <main_menu_font>
		Text = ''
		event_handlers = [
			{Focus retail_menu_focus Params = {Id = main_menu_training_text}}
			{Focus SetScreenElementProps Params = {Id = main_menu_training_text no_shadow}}
			{Focus guitar_menu_highlighter Params = {
					hlIndex = 4
					hlInfoList = <gm_hlInfoList>
					be1ID = <bookEnd1ID>
					be2ID = <bookEnd2ID>
					wthlID = <whiteTexHighlightID>
					text_id = main_menu_training_text
				}
			}
			{unfocus SetScreenElementProps Params = {Id = main_menu_training_text Shadow shadow_offs = (3.0, 3.0) shadow_rgba = [0 0 0 255]}}
			{unfocus retail_menu_unfocus Params = {Id = main_menu_training_text}}
			{pad_choose main_menu_select_training}
		]
		z_priority = -1
	}
	CreateScreenElement {
			Type = TextElement
			PARENT = vmenu_main_menu
			font = <main_menu_font>
			Text = ''
			event_handlers = [
				{Focus retail_menu_focus Params = {Id = main_menu_custom_menu_text}}
				{Focus SetScreenElementProps Params = {Id = main_menu_custom_menu_text no_shadow}}
					{Focus guitar_menu_highlighter Params = {
						hlIndex = 6
						hlInfoList = <gm_hlInfoList>
						be1ID = <bookEnd1ID>
						be2ID = <bookEnd2ID>
						wthlID = <whiteTexHighlightID>
						text_id = main_menu_custom_menu_text
					}
				}
				{unfocus SetScreenElementProps Params = {Id = main_menu_custom_menu_text Shadow shadow_offs = (3.0, 3.0) shadow_rgba = [0 0 0 255]}}
				{unfocus retail_menu_unfocus Params = {Id = main_menu_custom_menu_text}}
				{pad_choose ui_flow_manager_respond_to_action Params = {action = select_custom_menu}}
			]
			z_priority = -1
		}
	CreateScreenElement {
		Type = TextElement
		PARENT = vmenu_main_menu
		font = <main_menu_font>
		Text = ''
		event_handlers = [
			{Focus retail_menu_focus Params = {Id = main_menu_options_text}}
			{Focus SetScreenElementProps Params = {Id = main_menu_options_text no_shadow}}
			{Focus guitar_menu_highlighter Params = {
					hlIndex = 7
					hlInfoList = <gm_hlInfoList>
					be1ID = <bookEnd1ID>
					be2ID = <bookEnd2ID>
					wthlID = <whiteTexHighlightID>
					text_id = main_menu_options_text
				}
			}
			{unfocus SetScreenElementProps Params = {Id = main_menu_options_text Shadow shadow_offs = (3.0, 3.0) shadow_rgba = [0 0 0 255]}}
			{unfocus retail_menu_unfocus Params = {Id = main_menu_options_text}}
			{pad_choose main_menu_select_options}
		]
		z_priority = -1
	}
	if ((IsXENON) || (IsPS3) || (IsNGC))
		CreateScreenElement {
			Type = TextElement
			PARENT = vmenu_main_menu
			font = <main_menu_font>
			Text = ''
			event_handlers = [
				{Focus retail_menu_focus Params = {Id = main_menu_leaderboards_text}}
				{Focus SetScreenElementProps Params = {Id = main_menu_leaderboards_text no_shadow}}
				{Focus guitar_menu_highlighter Params = {
						hlIndex = 5
						hlInfoList = <gm_hlInfoList>
						be1ID = <bookEnd1ID>
						be2ID = <bookEnd2ID>
						wthlID = <whiteTexHighlightID>
						text_id = main_menu_leaderboards_text
					}
				}
				{unfocus SetScreenElementProps Params = {Id = main_menu_leaderboards_text Shadow shadow_offs = (3.0, 3.0) shadow_rgba = [0 0 0 255]}}
				{unfocus retail_menu_unfocus Params = {Id = main_menu_leaderboards_text}}
				{pad_choose main_menu_select_xbox_live}
			]
			z_priority = -1
			<demo_mode_disable>
		}
	endif
	if ($enable_button_cheats = 1)
		CreateScreenElement {
			Type = TextElement
			PARENT = vmenu_main_menu
			font = <main_menu_font>
			Text = ''
			event_handlers = [
				{Focus retail_menu_focus Params = {Id = main_menu_debug_menu_text}}
				{Focus guitar_menu_highlighter Params = {
						zPri = -2
						hlIndex = 0
						hlInfoList = <gm_hlInfoList>
						be1ID = <bookEnd1ID>
						be2ID = <bookEnd2ID>
						wthlID = <whiteTexHighlightID>
					}
				}
				{unfocus retail_menu_unfocus Params = {Id = main_menu_debug_menu_text}}
				{pad_choose ui_flow_manager_respond_to_action Params = {action = select_debug_menu}}
			]
			z_priority = -1
		}
	endif

	if ($new_message_of_the_day = 1)
		SpawnScriptNow \{pop_in_new_downloads_notifier}
	endif

	if ((ISPS3) || (IsXENON)) 
		Change \{user_control_pill_text_color = [
			0
			0
			0
			255
		]}
		Change \{user_control_pill_color = [
			180
			180
			180
			255
		]}
	endif

	add_user_control_helper \{Text = 'SELECT'
		button = Green
		Z = 100}
	add_user_control_helper \{Text = 'UP/DOWN'
		button = Strumbar
		Z = 100}
	if NOT ($invite_controller = -1)
		Change \{invite_controller = -1}
		ui_flow_manager_respond_to_action \{action = select_xbox_live}
		FadeToBlack \{OFF
			Time = 0}
	else
		LaunchEvent \{Type = Focus
			Target = vmenu_main_menu}
	endif
	0x5c83e977
endscript

script create_pause_menu \{Player = 1
		for_options = 0
		for_practice = 0}
	player_device = ($last_start_pressed_device)
	if ($player1_device = <player_device>)
		<Player> = 1
	else
		<Player> = 2
	endif
	if (<for_options> = 0)
		if ($view_mode)
			return
		endif
		enable_pause
		safe_create_gh3_pause_menu
	else
		kill_start_key_binding
		flame_handlers = [
			{pad_back ui_flow_manager_respond_to_action Params = {action = go_back}}
			{pad_up generic_menu_up_or_down_sound Params = {UP}}
			{pad_down generic_menu_up_or_down_sound Params = {UP}}
		]
	endif
	Change \{bunny_flame_index = 1}
	pause_z = 10000
	Spacing = -65
	if (<for_options> = 0)
		Menu_pos = (730.0, 220.0)
		if (<for_practice> = 1)
			<Menu_pos> = (640.0, 190.0)
		endif
		<Spacing> = -65
	else
		<Spacing> = -55
		if IsGuitarController controller = <player_device>
			Menu_pos = (640.0, 225.0)
		else
			Menu_pos = (640.0, 250.0)
		endif
	endif
	new_menu {
		scrollid = scrolling_pause
		vmenuid = vmenu_pause
		Menu_pos = <Menu_pos>
		Rot_Angle = 2
		event_handlers = <flame_handlers>
		Spacing = <Spacing>
		use_backdrop = (0)
		exclusive_device = <player_device>
	}
	create_pause_menu_frame Z = (<pause_z> - 10)
	if ($is_network_game = 0)
		CreateScreenElement {
			Type = SpriteElement
			PARENT = pause_menu_frame_container
			texture = menu_pause_frame_banner
			Pos = (640.0, 540.0)
			just = [Center Center]
			z_priority = (<pause_z> + 100)
		}
		if GotParam \{banner_text}
			pause_player_text = <banner_text>
			if GotParam \{banner_scale}
				pause_player_scale = <banner_scale>
			else
				pause_player_scale = (1.0, 1.0)
			endif
		else
			if (<for_options> = 0)
				if (<for_practice> = 1)
					<pause_player_text> = 'PAUSED'
				else
					if NOT IsSinglePlayerGame
						FormatText TextName = pause_player_text 'P%d PAUSED' D = <Player>
					else
						<pause_player_text> = 'PAUSED'
					endif
				endif
				pause_player_scale = (0.75, 0.75)
			else
				pause_player_text = 'OPTIONS'
				pause_player_scale = (0.75, 0.75)
			endif
		endif
	endif

	pause_player_pos = (125.0, 47.0)
	if ((IsXenon) || (IsPS3))
		pause_player_pos = (125.0, 52.0)
	endif

	CreateScreenElement {
		Type = TextElement
		PARENT = <Id>
		Text = <pause_player_text>
		font = text_a6
		Pos = <pause_player_pos>
		Scale = <pause_player_scale>
		rgba = [170 90 30 255]
		Scale = 0.8
	}
	text_scale = (0.9, 0.9)
	if (<for_options> = 0 && <for_practice> = 0 && $is_network_game = 0)
		CreateScreenElement {
			Type = ContainerElement
			PARENT = pause_menu_frame_container
			Id = bunny_container
			Pos = (380.0, 170.0)
			just = [LEFT Top]
			z_priority = <pause_z>
		}
		I = 1
		begin
		FormatText ChecksumName = bunny_id 'pause_bunny_flame_%d' D = <I>
		FormatText ChecksumName = bunny_tex 'GH3_Pause_Bunny_Flame%d' D = <I>
		CreateScreenElement {
			Type = SpriteElement
			Id = <bunny_id>
			PARENT = bunny_container
			Pos = (160.0, 170.0)
			texture = <bunny_tex>
			rgba = [255 255 255 255]
			Dims = (300.0, 300.0)
			just = [RIGHT Bottom]
			z_priority = (<pause_z> + 3)
			Rot_Angle = 5
		}
		if (<I> > 1)
			DoScreenElementMorph Id = <bunny_id> Alpha = 0
		endif
		<I> = (<I> + 1)
		repeat 7
		CreateScreenElement {
			Type = SpriteElement
			Id = pause_bunny_shadow
			PARENT = bunny_container
			texture = GH3_Pause_Bunny
			rgba = [0 0 0 128]
			Pos = (20.0, -110.0)
			Dims = (550.0, 550.0)
			just = [Center Top]
			z_priority = (<pause_z> + 4)
		}
		CreateScreenElement {
			Type = SpriteElement
			Id = pause_bunny
			PARENT = bunny_container
			texture = GH3_Pause_Bunny
			rgba = [255 255 255 255]
			Pos = (0.0, -130.0)
			Dims = (550.0, 550.0)
			just = [Center Top]
			z_priority = (<pause_z> + 5)
		}
		RunScriptOnScreenElement \{Id = bunny_container
			bunny_hover
			Params = {
				hover_origin = (380.0, 170.0)
			}}
	endif
	container_params = {Type = ContainerElement PARENT = vmenu_pause Dims = (0.0, 100.0)}
	if (<for_options> = 0)
		if (<for_practice> = 1)
			if English
			else
				text_scale = (0.71999997, 0.71999997)
			endif
			CreateScreenElement {
				<container_params>
				event_handlers = [
					{Focus retail_menu_focus Params = {Id = pause_resume}}
					{unfocus retail_menu_unfocus Params = {Id = pause_resume}}
					{pad_choose gh3_start_pressed}
				]
			}
			CreateScreenElement {
				Type = TextElement
				PARENT = <Id>
				font = fontgrid_title_gh3
				Scale = <text_scale>
				rgba = [210 130 0 250]
				Id = pause_resume
				Text = 'RESUME'
				just = [Center Top]
				Shadow
				shadow_offs = (3.0, 3.0)
				shadow_rgba [0 0 0 255]
				z_priority = <pause_z>
				exclusive_device = <player_device>
			}
			GetScreenElementDims Id = <Id>
			fit_text_in_rectangle Id = <Id> Dims = ((300.0, 0.0) + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
			CreateScreenElement {
				<container_params>
				event_handlers = [
					{Focus retail_menu_focus Params = {Id = pause_restart}}
					{unfocus retail_menu_unfocus Params = {Id = pause_restart}}
					{pad_choose ui_flow_manager_respond_to_action Params = {action = select_restart}}
				]
			}
			CreateScreenElement {
				Type = TextElement
				PARENT = <Id>
				font = fontgrid_title_gh3
				Scale = <text_scale>
				rgba = [210 130 0 250]
				Text = 'RESTART'
				Id = pause_restart
				just = [Center Top]
				Shadow
				shadow_offs = (3.0, 3.0)
				shadow_rgba [0 0 0 255]
				z_priority = <pause_z>
				exclusive_device = <player_device>
			}
			GetScreenElementDims Id = <Id>
			fit_text_in_rectangle Id = <Id> Dims = ((300.0, 0.0) + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
			CreateScreenElement {
				<container_params>
				event_handlers = [
					{Focus retail_menu_focus Params = {Id = pause_options}}
					{unfocus retail_menu_unfocus Params = {Id = pause_options}}
					{pad_choose ui_flow_manager_respond_to_action Params = {action = select_options create_params = {player_device = <player_device>}}}
				]
			}
			CreateScreenElement {
				Type = TextElement
				PARENT = <Id>
				font = fontgrid_title_gh3
				Scale = <text_scale>
				rgba = [210 130 0 250]
				Text = 'OPTIONS'
				Id = pause_options
				just = [Center Top]
				Shadow
				shadow_offs = (3.0, 3.0)
				shadow_rgba [0 0 0 255]
				z_priority = <pause_z>
				exclusive_device = <player_device>
			}
			GetScreenElementDims Id = <Id>
			fit_text_in_rectangle Id = <Id> Dims = ((300.0, 0.0) + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
			CreateScreenElement {
				<container_params>
				event_handlers = [
					{Focus retail_menu_focus Params = {Id = pause_change_speed}}
					{unfocus retail_menu_unfocus Params = {Id = pause_change_speed}}
					{pad_choose ui_flow_manager_respond_to_action Params = {action = select_change_speed}}
				]
			}
			CreateScreenElement {
				Type = TextElement
				PARENT = <Id>
				font = fontgrid_title_gh3
				Scale = <text_scale>
				rgba = [210 130 0 250]
				Text = 'CHANGE SPEED'
				Id = pause_change_speed
				just = [Center Top]
				Shadow
				shadow_offs = (3.0, 3.0)
				shadow_rgba [0 0 0 255]
				z_priority = <pause_z>
				exclusive_device = <player_device>
			}
			GetScreenElementDims Id = <Id>
			fit_text_in_rectangle Id = <Id> Dims = ((300.0, 0.0) + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
			CreateScreenElement {
				<container_params>
				event_handlers = [
					{Focus retail_menu_focus Params = {Id = pause_change_section}}
					{unfocus retail_menu_unfocus Params = {Id = pause_change_section}}
					{pad_choose ui_flow_manager_respond_to_action Params = {action = select_change_section}}
				]
			}
			CreateScreenElement {
				Type = TextElement
				PARENT = <Id>
				font = fontgrid_title_gh3
				Scale = <text_scale>
				rgba = [210 130 0 250]
				Text = 'CHANGE SECTION'
				Id = pause_change_section
				just = [Center Top]
				Shadow
				shadow_offs = (3.0, 3.0)
				shadow_rgba [0 0 0 255]
				z_priority = <pause_z>
				exclusive_device = <player_device>
			}
			GetScreenElementDims Id = <Id>
			fit_text_in_rectangle Id = <Id> Dims = ((300.0, 0.0) + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
			if ($came_to_practice_from = main_menu)
				CreateScreenElement {
					<container_params>
					event_handlers = [
						{Focus retail_menu_focus Params = {Id = pause_new_song}}
						{unfocus retail_menu_unfocus Params = {Id = pause_new_song}}
						{pad_choose ui_flow_manager_respond_to_action Params = {action = select_new_song}}
					]
				}
				CreateScreenElement {
					Type = TextElement
					PARENT = <Id>
					font = fontgrid_title_gh3
					Scale = <text_scale>
					rgba = [210 130 0 250]
					Text = 'NEW SONG'
					Id = pause_new_song
					just = [Center Top]
					Shadow
					shadow_offs = (3.0, 3.0)
					shadow_rgba [0 0 0 255]
					z_priority = <pause_z>
					exclusive_device = <player_device>
				}
				GetScreenElementDims Id = <Id>
				fit_text_in_rectangle Id = <Id> Dims = ((300.0, 0.0) + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
			endif
			CreateScreenElement {
				<container_params>
				event_handlers = [
					{Focus retail_menu_focus Params = {Id = pause_quit}}
					{unfocus retail_menu_unfocus Params = {Id = pause_quit}}
					{pad_choose ui_flow_manager_respond_to_action Params = {action = select_quit}}
				]
			}
			CreateScreenElement {
				Type = TextElement
				PARENT = <Id>
				font = fontgrid_title_gh3
				Scale = <text_scale>
				rgba = [210 130 0 250]
				Text = 'QUIT'
				Id = pause_quit
				just = [Center Top]
				Shadow
				shadow_offs = (3.0, 3.0)
				shadow_rgba [0 0 0 255]
				z_priority = <pause_z>
				exclusive_device = <player_device>
			}
			GetScreenElementDims Id = <Id>
			fit_text_in_rectangle Id = <Id> Dims = ((300.0, 0.0) + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
			add_user_control_helper \{Text = 'SELECT'
				button = Green
				Z = 100000}
			add_user_control_helper \{Text = 'UP/DOWN'
				button = Strumbar
				Z = 100000}
		else
			if English
			else
				container_params = {Type = ContainerElement PARENT = vmenu_pause Dims = (0.0, 105.0)}
				text_scale = (0.8, 0.8)
			endif
			CreateScreenElement {
				<container_params>
				event_handlers = [
					{Focus retail_menu_focus Params = {Id = pause_resume}}
					{unfocus retail_menu_unfocus Params = {Id = pause_resume}}
					{pad_choose gh3_start_pressed}
				]
			}
			CreateScreenElement {
				Type = TextElement
				PARENT = <Id>
				font = fontgrid_title_gh3
				Scale = <text_scale>
				rgba = [210 130 0 250]
				Text = 'RESUME'
				Id = pause_resume
				just = [Center Top]
				Shadow
				shadow_offs = (3.0, 3.0)
				shadow_rgba [0 0 0 255]
				z_priority = <pause_z>
				exclusive_device = <player_device>
			}
			GetScreenElementDims Id = <Id>
			if ($is_network_game = 0)
				fit_text_in_rectangle Id = <Id> Dims = ((250.0, 0.0) + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
			else
				fit_text_in_rectangle Id = <Id> Dims = ((300.0, 0.0) + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
			endif
			if ($is_network_game = 0)
				if NOT ($end_credits = 1)
					CreateScreenElement {
						<container_params>
						event_handlers = [
							{Focus retail_menu_focus Params = {Id = pause_restart}}
							{unfocus retail_menu_unfocus Params = {Id = pause_restart}}
							{pad_choose ui_flow_manager_respond_to_action Params = {action = select_restart}}
						]
					}
					CreateScreenElement {
						Type = TextElement
						PARENT = <Id>
						font = fontgrid_title_gh3
						Scale = <text_scale>
						rgba = [210 130 0 250]
						Text = 'RESTART'
						Id = pause_restart
						just = [Center Top]
						Shadow
						shadow_offs = (3.0, 3.0)
						shadow_rgba [0 0 0 255]
						z_priority = <pause_z>
						exclusive_device = <player_device>
					}
					GetScreenElementDims Id = <Id>
					fit_text_in_rectangle Id = <Id> Dims = ((250.0, 0.0) + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
					if ($is_demo_mode = 1)
						demo_mode_disable = {rgba = [80 80 80 255] NOT_FOCUSABLE}
					else
						demo_mode_disable = {}
					endif
					if (($game_mode = p1_career && $boss_battle = 0) || ($game_mode = p1_quickplay))
						CreateScreenElement {
							<container_params>
							event_handlers = [
								{Focus retail_menu_focus Params = {Id = pause_practice}}
								{unfocus retail_menu_unfocus Params = {Id = pause_practice}}
								{pad_choose ui_flow_manager_respond_to_action Params = {action = select_practice}}
							]
						}
						CreateScreenElement {
							Type = TextElement
							PARENT = <Id>
							font = fontgrid_title_gh3
							Scale = <text_scale>
							rgba = [210 130 0 250]
							Text = 'PRACTICE'
							Id = pause_practice
							just = [Center Top]
							Shadow
							shadow_offs = (3.0, 3.0)
							shadow_rgba [0 0 0 255]
							z_priority = <pause_z>
							exclusive_device = <player_device>
							<demo_mode_disable>
						}
						GetScreenElementDims Id = <Id>
						fit_text_in_rectangle Id = <Id> Dims = ((260.0, 0.0) + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
					endif
					CreateScreenElement {
						<container_params>
						event_handlers = [
							{Focus retail_menu_focus Params = {Id = pause_options}}
							{unfocus retail_menu_unfocus Params = {Id = pause_options}}
							{pad_choose ui_flow_manager_respond_to_action Params = {action = select_options create_params = {player_device = <player_device>}}}
						]
					}
					CreateScreenElement {
						Type = TextElement
						PARENT = <Id>
						font = fontgrid_title_gh3
						Scale = <text_scale>
						rgba = [210 130 0 250]
						Text = 'OPTIONS'
						Id = pause_options
						just = [Center Top]
						Shadow
						shadow_offs = (3.0, 3.0)
						shadow_rgba [0 0 0 255]
						z_priority = <pause_z>
						exclusive_device = <player_device>
					}
					GetScreenElementDims Id = <Id>
					fit_text_in_rectangle Id = <Id> Dims = ((260.0, 0.0) + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
				endif
			endif
			quit_script = ui_flow_manager_respond_to_action
			quit_script_params = {action = select_quit create_params = {Player = <Player>}}
			if ($is_network_game)
				quit_script = create_leaving_lobby_dialog
				quit_script_params = {
					create_pause_menu
					pad_back_script = return_to_pause_menu_from_net_warning
					pad_choose_script = pause_menu_really_quit_net_game
					Z = 300
				}
			endif
			CreateScreenElement {
				<container_params>
				event_handlers = [
					{Focus retail_menu_focus Params = {Id = pause_quit}}
					{unfocus retail_menu_unfocus Params = {Id = pause_quit}}
					{pad_choose <quit_script> Params = <quit_script_params>}
				]
			}
			CreateScreenElement {
				Type = TextElement
				PARENT = <Id>
				font = fontgrid_title_gh3
				Scale = <text_scale>
				rgba = [210 130 0 250]
				Text = 'QUIT'
				Id = pause_quit
				just = [Center Top]
				Shadow
				shadow_offs = (3.0, 3.0)
				shadow_rgba [0 0 0 255]
				z_priority = <pause_z>
				exclusive_device = <player_device>
			}
			GetScreenElementDims Id = <Id>
			if ($is_network_game = 0)
				fit_text_in_rectangle Id = <Id> Dims = ((270.0, 0.0) + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
			else
				fit_text_in_rectangle Id = <Id> Dims = ((300.0, 0.0) + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
			endif
			if ($enable_button_cheats = 1)
				CreateScreenElement {
					<container_params>
					event_handlers = [
						{Focus retail_menu_focus Params = {Id = pause_debug_menu}}
						{unfocus retail_menu_unfocus Params = {Id = pause_debug_menu}}
						{pad_choose ui_flow_manager_respond_to_action Params = {action = select_debug_menu}}
					]
				}
				CreateScreenElement {
					Type = TextElement
					PARENT = <Id>
					font = fontgrid_title_gh3
					Scale = <text_scale>
					rgba = [210 130 0 250]
					Text = 'DEBUG MENU'
					Id = pause_debug_menu
					just = [Center Top]
					Shadow
					shadow_offs = (3.0, 3.0)
					shadow_rgba [0 0 0 255]
					z_priority = <pause_z>
					exclusive_device = <player_device>
				}
			endif
			add_user_control_helper \{Text = 'SELECT'
				button = Green
				Z = 100000}
			add_user_control_helper \{Text = 'UP/DOWN'
				button = Strumbar
				Z = 100000}
		endif
	else
		<fit_dims> = (500.0, 0.0)
		CreateScreenElement {
			Type = ContainerElement
			PARENT = vmenu_pause
			Dims = (0.0, 100.0)
			event_handlers = [
				{Focus retail_menu_focus Params = {Id = options_audio}}
				{Focus generic_menu_up_or_down_sound}
				{unfocus retail_menu_unfocus Params = {Id = options_audio}}
				{pad_choose ui_flow_manager_respond_to_action Params = {action = select_audio_settings create_params = {Player = <Player>}}}
			]
		}
		CreateScreenElement {
			Type = TextElement
			PARENT = <Id>
			font = fontgrid_title_gh3
			Scale = <text_scale>
			rgba = [210 130 0 250]
			Text = 'SET AUDIO'
			Id = options_audio
			just = [Center Center]
			Shadow
			shadow_offs = (3.0, 3.0)
			shadow_rgba [0 0 0 255]
			z_priority = <pause_z>
			exclusive_device = <player_device>
		}
		if ((IsWinPort) || (IsMacPort))
			GetScreenElementDims Id = <Id>
			fit_text_in_rectangle Id = <Id> Dims = (<fit_dims> + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
			CreateScreenElement {
				Type = ContainerElement
				PARENT = vmenu_pause
				Dims = (0.0, 100.0)
				event_handlers = [
					{Focus retail_menu_focus Params = {Id = options_calibrate_lag}}
					{Focus generic_menu_up_or_down_sound}
					{unfocus retail_menu_unfocus Params = {Id = options_calibrate_lag}}
					{pad_choose ui_flow_manager_respond_to_action Params = {action = select_calibrate_lag create_params = {Player = <Player>}}}
				]
			}
			CreateScreenElement {
				Type = TextElement
				PARENT = <Id>
				font = fontgrid_title_gh3
				Scale = <text_scale>
				rgba = [210 130 0 250]
				Text = 'CALIBRATE VIDEO LAG'
				Id = options_calibrate_lag
				just = [Center Center]
				Shadow
				shadow_offs = (3.0, 3.0)
				shadow_rgba [0 0 0 255]
				z_priority = <pause_z>
				exclusive_device = <player_device>
			}
			GetScreenElementDims Id = <Id>
			fit_text_in_rectangle Id = <Id> Dims = (<fit_dims> + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
			CreateScreenElement {
				Type = ContainerElement
				PARENT = vmenu_pause
				Dims = (0.0, 100.0)
				event_handlers = [
					{Focus retail_menu_focus Params = {Id = 0x06c938f2}}
					{Focus generic_menu_up_or_down_sound}
					{unfocus retail_menu_unfocus Params = {Id = 0x06c938f2}}
					{pad_choose ui_flow_manager_respond_to_action Params = {action = 0xb1f15fbe create_params = {Player = <Player>}}}
				]
			}
			CreateScreenElement {
				Type = TextElement
				PARENT = <Id>
				font = fontgrid_title_gh3
				Scale = <text_scale>
				rgba = [210 130 0 250]
				Text = 'CALIBRATE AUDIO LAG'
				Id = 0x06c938f2
				just = [Center Center]
				Shadow
				shadow_offs = (3.0, 3.0)
				shadow_rgba [0 0 0 255]
				z_priority = <pause_z>
				exclusive_device = <player_device>
			}
		else
		GetScreenElementDims Id = <Id>
			fit_text_in_rectangle Id = <Id> Dims = (<fit_dims> + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
			CreateScreenElement {
				Type = ContainerElement
				PARENT = vmenu_pause
				Dims = (0.0, 100.0)
				event_handlers = [
					{Focus retail_menu_focus Params = {Id = options_calibrate_lag}}
					{Focus generic_menu_up_or_down_sound}
					{unfocus retail_menu_unfocus Params = {Id = options_calibrate_lag}}
					{pad_choose ui_flow_manager_respond_to_action Params = {action = select_calibrate_lag create_params = {Player = <Player>}}}
				]
			}
			CreateScreenElement {
				Type = TextElement
				PARENT = <Id>
				font = fontgrid_title_gh3
				Scale = <text_scale>
				rgba = [210 130 0 250]
				Text = 'CALIBRATE LAG'
				Id = options_calibrate_lag
				just = [Center Center]
				Shadow
				shadow_offs = (3.0, 3.0)
				shadow_rgba [0 0 0 255]
				z_priority = <pause_z>
				exclusive_device = <player_device>
			}
		endif
		GetScreenElementDims Id = <Id>
		fit_text_in_rectangle Id = <Id> Dims = (<fit_dims> + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
		if IsGuitarController controller = <player_device>
			CreateScreenElement {
				Type = ContainerElement
				PARENT = vmenu_pause
				Dims = (0.0, 100.0)
				event_handlers = [
					{Focus retail_menu_focus Params = {Id = options_calibrate_whammy}}
					{Focus generic_menu_up_or_down_sound}
					{unfocus retail_menu_unfocus Params = {Id = options_calibrate_whammy}}
					{pad_choose ui_flow_manager_respond_to_action Params = {action = select_calibrate_whammy_bar create_params = {Player = <Player> Popup = 1}}}
				]
			}
			CreateScreenElement {
				Type = TextElement
				PARENT = <Id>
				font = fontgrid_title_gh3
				Scale = <text_scale>
				rgba = [210 130 0 250]
				Text = 'CALIBRATE WHAMMY'
				Id = options_calibrate_whammy
				just = [Center Center]
				Shadow
				shadow_offs = (3.0, 3.0)
				shadow_rgba [0 0 0 255]
				z_priority = <pause_z>
				exclusive_device = <player_device>
			}
			GetScreenElementDims Id = <Id>
			fit_text_in_rectangle Id = <Id> Dims = (<fit_dims> + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
		endif
		if IsSinglePlayerGame
			lefty_flip_text = 'LEFTY FLIP:'
		else
			if (<Player> = 1)
				lefty_flip_text = 'P1 LEFTY FLIP:'
			else
				lefty_flip_text = 'P2 LEFTY FLIP:'
			endif
		endif
		CreateScreenElement {
			Type = ContainerElement
			PARENT = vmenu_pause
			Dims = (0.0, 100.0)
			event_handlers = [
				{Focus retail_menu_focus Params = {Id = pause_options_lefty}}
				{Focus generic_menu_up_or_down_sound}
				{unfocus retail_menu_unfocus Params = {Id = pause_options_lefty}}
				{pad_choose ui_flow_manager_respond_to_action Params = {action = select_lefty_flip create_params = {Player = <Player>}}}
			]
		}
		<lefty_container> = <Id>
		CreateScreenElement {
			Type = TextElement
			PARENT = <lefty_container>
			Id = pause_options_lefty
			font = fontgrid_title_gh3
			Scale = <text_scale>
			rgba = [210 130 0 250]
			Text = <lefty_flip_text>
			just = [Center Center]
			Shadow
			shadow_offs = (3.0, 3.0)
			shadow_rgba [0 0 0 255]
			z_priority = <pause_z>
			exclusive_device = <player_device>
		}
		GetScreenElementDims Id = <Id>
		fit_text_in_rectangle Id = <Id> Dims = (<fit_dims> + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
		CreateScreenElement {
			Type = ContainerElement
			PARENT = vmenu_pause
			Dims = (0.0, 100.0)
			event_handlers = [
				{Focus retail_menu_focus Params = {Id = options_deluxe}}
				{Focus generic_menu_up_or_down_sound}
				{unfocus retail_menu_unfocus Params = {Id = options_deluxe}}
				{pad_choose ui_flow_manager_respond_to_action Params = {action = select_deluxe_settings create_params = {Player = <Player>}}}
			]
		}
		CreateScreenElement {
			Type = TextElement
			PARENT = <Id>
			font = fontgrid_title_gh3
			Scale = <text_scale>
			rgba = [210 130 0 250]
			Text = 'DELUXE SETTINGS'
			Id = options_deluxe
			just = [Center Center]
			Shadow
			shadow_offs = (3.0, 3.0)
			shadow_rgba [0 0 0 255]
			z_priority = <pause_z>
			exclusive_device = <player_device>
		}
		GetScreenElementDims Id = <Id>
		fit_text_in_rectangle Id = <Id> Dims = (<fit_dims> + <Height> * (0.0, 1.0)) only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0)) start_y_scale = (<text_scale>.(0.0, 1.0))
		GetGlobalTags \{user_options}
		if (<Player> = 1)
			if (<lefty_flip_p1> = 1)
				lefty_tex = Options_Controller_Check
			else
				lefty_tex = Options_Controller_X
			endif
		else
			if (<lefty_flip_p2> = 1)
				lefty_tex = Options_Controller_Check
			else
				lefty_tex = Options_Controller_X
			endif
		endif
		displaySprite {
			PARENT = <lefty_container>
			tex = <lefty_tex>
			just = [Center Center]
			Z = (<pause_z> + 10)
		}
		GetScreenElementDims \{Id = pause_options_lefty}
		<Id> :SetProps Pos = (<width> * (0.5, 0.0) + (22.0, 0.0))
		add_user_control_helper \{Text = 'SELECT'
			button = Green
			Z = 100000}
		add_user_control_helper \{Text = 'BACK'
			button = RED
			Z = 100000}
		add_user_control_helper \{Text = 'UP/DOWN'
			button = Strumbar
			Z = 100000}
	endif
	if ($is_network_game = 0)
		if NOT IsSinglePlayerGame
			if (<for_practice> = 0)
				FormatText TextName = player_paused_text 'PLAYER %d PAUSED. ONLY PLAYER %d OPTIONS ARE AVAILABLE.' D = <Player>
				displaySprite {
					PARENT = pause_menu_frame_container
					Id = pause_helper_text_bg
					tex = Control_pill_body
					Pos = (640.0, 600.0)
					just = [Center Center]
					rgba = [96 0 0 255]
					Z = (<pause_z> + 10)
				}
				displayText {
					PARENT = pause_menu_frame_container
					Pos = (640.0, 600.0)
					just = [Center Center]
					Text = <player_paused_text>
					rgba = [186 105 0 255]
					Scale = (0.55, 0.65000004)
					Z = (<pause_z> + 11)
					font = text_a6
				}
				GetScreenElementDims Id = <Id>
				bg_dims = (<width> * (1.0, 0.0) + (0.0, 32.0))
				pause_helper_text_bg :SetProps Dims = <bg_dims>
				displaySprite {
					PARENT = pause_menu_frame_container
					tex = Control_pill_end
					Pos = ((640.0, 600.0) - <width> * (0.5, 0.0))
					rgba = [96 0 0 255]
					just = [RIGHT Center]
					flip_v
					Z = (<pause_z> + 10)
				}
				displaySprite {
					PARENT = pause_menu_frame_container
					tex = Control_pill_end
					Pos = ((640.0, 601.0) + <width> * (0.5, 0.0))
					rgba = [96 0 0 255]
					just = [LEFT Center]
					Z = (<pause_z> + 10)
				}
			endif
		endif
	endif
	Change \{menu_choose_practice_destroy_previous_menu = 1}
	if (<for_options> = 0 && <for_practice> = 0 && $is_network_game = 0)
		SpawnScriptNow \{animate_bunny_flame}
	endif
endscript