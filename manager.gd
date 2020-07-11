extends Node

const AUDIO_SCENE = preload ("res://audio.tscn")

var music_node

func _ready():
	_create_music_node()
	
func load_title():
	pass
	#placeholder: will be used to load the title scene

func load_game():
	pass
	#placeholder: will be used to load the game scene
func _create_music_node():
	music_node = AUDIO_SCENE.instance()
	_couple_music_node()

func _couple_music_node():
	get_tree().get_root().call_deferred("add child", music_node)

func _decouple_music_node():
	get_tree().get_root().remove_child(music_node)

func _switch_scene(next_scene):
	_decouple_music_node()
	get_tree().change_scene_to(next_scene)
	_couple_music_node()
