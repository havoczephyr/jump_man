extends Spatial
var tile_scene = preload("res://tile_set.tscn")

export(float) var spawn_timer = 2
var timer = -4.0

export(int) var active_tile_sets = 4
var tile_set_array = {}
var tile_count = 0
var write_head = 0

var scale_min = 2.0
var scale_max = 4.0
var trans_rad = 6.0
var height_var = 4.0
var rng = RandomNumberGenerator.new()


func _ready():
	Manager.audio_lib.play_bg_music()
	rng.randomize()
	for i in range (0, active_tile_sets):
		spawn_tile()


func _process(delta):
	timer += delta
	if timer >= spawn_timer:
		timer -= spawn_timer
		remove_tile()
		spawn_tile()
		

func spawn_tile():
	var tile_instance = tile_scene.instance()
	add_child(tile_instance)
	tile_set_array [write_head] = tile_instance
	write_head = (write_head + 1) % active_tile_sets
	tile_count += 1
	
	
	var cyan = tile_instance.get_node("cyan_tile")
	var magenta = tile_instance.get_node("magenta_tile")
	var grey = tile_instance.get_node("grey_tile")
	var tile_shuffle = [cyan, magenta, grey]
	tile_shuffle.shuffle()
		#set position
	var tile_set_center = Vector3(0,0,-12.5 * tile_count)
	var tile_set_right = Vector3(12.5,0,-12.5 * tile_count)
	var tile_set_left = Vector3(-12.5,0,-12.5 * tile_count)
	var position_arr = [tile_set_center, tile_set_right, tile_set_left]
	for i in range(0, tile_shuffle.size()):
		tile_shuffle[i].translation = get_random_offset(position_arr[i])
		#set scale
		tile_shuffle[i].scale = get_random_scale()
	

func remove_tile():
	tile_set_array [write_head].queue_free()

func get_random_scale():
	return Vector3 (rng.randf_range(scale_min, scale_max),1,rng.randf_range(scale_min, scale_max))

func get_random_offset(center):
	var radius = rng.randf_range(0,trans_rad)
	var angle = rng.randf_range(0, 2 * PI)
	var height = rng.randf_range(0.0,height_var)
	return Vector3 (cos(angle) * radius, height, sin(angle) * radius) + center
	
	
