extends Node

func play_title_music():
	$tit_music.play()
	$bg_music.stop()

func play_bg_music():
	$bg_music.play()
	$tit_music.stop()
