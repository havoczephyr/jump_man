extends Node

func play_title_music():
	$music_audio/tit_music.play()
	$music_audio/bg_music.stop()

func play_bg_music():
	$music_audio/bg_music.play()
	$music_audio/tit_music.stop()



func play_jump_start():
	$player_audio/au_jump_start.play()

func play_jump_land():
	$player_audio/au_jump_land.play()

func play_death():
	$player_audio/au_death.play()
	
func play_walk():
	$player_audio/au_walk.play()
