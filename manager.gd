extends Node

const AUDIO_SCENE = preload ("res://audio.tscn")
const GAME_SCENE = preload ("res://test_world.tscn")
const TITLE_SCENE = preload ("res://title_menu.tscn")

var audio_lib

func _ready():
	_create_audio_lib()
	
func load_title():
	_switch_scene(TITLE_SCENE)

func load_game():
	_switch_scene(GAME_SCENE)


func _create_audio_lib():
	audio_lib = AUDIO_SCENE.instance()
	_couple_audio_lib()

func _couple_audio_lib():
	get_tree().get_root().call_deferred("add_child", audio_lib)

func _decouple_audio_lib():
	get_tree().get_root().remove_child(audio_lib)

func _switch_scene(next_scene):
	_decouple_audio_lib()
	get_tree().change_scene_to(next_scene)
	_couple_audio_lib()
