extends Node

const AUDIO_SCENE = preload ("res://audio.tscn")

var audio_lib

func _ready():
	_create_audio_lib()
	
func load_title():
	pass
	#placeholder: will be used to load the title scene

func load_game():
	pass
	#placeholder: will be used to load the game scene
func _create_audio_lib():
	audio_lib = AUDIO_SCENE.instance()
	_couple_audio_lib()

func _couple_audio_lib():
	get_tree().get_root().call_deferred("add child", audio_lib)

func _decouple_audio_lib():
	get_tree().get_root().remove_child(audio_lib)

func _switch_scene(next_scene):
	_decouple_audio_lib()
	get_tree().change_scene_to(next_scene)
	_couple_audio_lib()
