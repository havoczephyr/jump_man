extends KinematicBody

#used for camera clamp
const QC_ARC = PI * 0.5

signal tile_detective (tile)

#momentum vars
export(float) var top_speed = 15
export(float) var accel = 65
export(float) var grav = 32
export(float) var jump_power = 18
export(float) var air_multi = 0.2
var air_jump = true


#camera scaler
export(float) var mouse_sens = 0.3

#establish node variables
onready var head = $head
onready var camera = $head/head_camera

var velocity = Vector3()

func _ready():
	cap_mouse()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		cap_mouse()

#locks mouse to center of the screen, will occur on load and can be toggled when EU returns to game.
func cap_mouse():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		

func kill():
	print ("reloading...")
	get_tree().reload_current_scene()
	
func jump():
	#velocity.y += jump_power
	velocity.y = jump_power

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sens))
		
		var x_delta = event.relative.y * mouse_sens
		
		#locks camera rotation above and below player
		head.rotation.x = clamp (head.rotation.x - deg2rad(x_delta), -QC_ARC, QC_ARC)

func _process(delta):
	if is_on_floor():
		air_jump = true
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reload"):
		kill()
		
func _physics_process(delta):
	var body_basis = get_global_transform().basis
	
	var direction = Vector3()
	
	#moving forward or backward
	var dot_z = velocity.dot(transform.basis.z)
	if Input.is_action_pressed("move_forw"):
		if dot_z > 0 && is_on_floor():
			velocity -= transform.basis.z * dot_z
		direction -= body_basis.z
	elif Input.is_action_pressed("move_back"):
		if dot_z < 0 && is_on_floor():
			velocity -= transform.basis.z * dot_z
		direction += body_basis.z
	
	#moving left or right
	var dot_x = velocity.dot(transform.basis.x)
	if Input.is_action_pressed("move_left"):
		if dot_x > 0 && is_on_floor():
			velocity -= transform.basis.x * dot_x
		direction -= body_basis.x
	elif Input.is_action_pressed("move_right"):
		if dot_x < 0 && is_on_floor():
			velocity -= transform.basis.x * dot_x
		direction += body_basis.x
	
	var step_accel = accel
	if !is_on_floor():
		step_accel *= air_multi
	
	#movement formula
	
	#value velocity is moving towards
	var target_vel = direction * top_speed
	target_vel = Vector2(target_vel.x, target_vel.z)

	velocity.y -= grav * delta
	if Input.get_action_strength("debug_floater") > 0:
		velocity.y = 1
		air_jump = true
	
	var planar_vel = Vector2(velocity.x, velocity.z)
	planar_vel = planar_vel.move_toward(target_vel, step_accel * delta)
	velocity = Vector3(planar_vel.x, velocity.y, planar_vel.y)
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			jump()
		elif air_jump:
			velocity.x *=0.5
			velocity.z *=0.5
			jump()
			air_jump = false
		
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if is_on_floor():
		var touched_floor = get_slide_collision(0).collider.get_parent()
		if touched_floor.name == "MeshInstance":
			return
		elif touched_floor.name == "cyan_tile":
			
		var tf_parent = touched_floor.get_parent()
		for i in range (0,tf_parent.get_child_count()):
			var child = tf_parent.get_child(i)
			if child.name != touched_floor.name:
				child.queue_free()
	
	
	
	

