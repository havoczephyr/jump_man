extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Manager.audio_lib.play_title_music()


func _on_Button_pressed():
	Manager.load_game()
