extends KinematicBody

#used for camera clamp
const QC_ARC = PI * 0.5

#momentum vars
export(float) var top_speed = 30
export(float) var accel = 75
export(float) var grav = 32
export(float) var jump_power = 35
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
	if Input.is_action_just_pressed("restart"):
		kill()
		
func _physics_process(delta):
	var body_basis = get_global_transform().basis
	
	var direction = Vector3()
	
	#moving forward or backward
	if Input.is_action_pressed("move_forw"):
		direction -= body_basis.z
	elif Input.is_action_pressed("move_back"):
		direction += body_basis.z
	
	#moving left or right
	if Input.is_action_pressed("move_left"):
		direction -= body_basis.x
	elif Input.is_action_pressed("move_right"):
		direction += body_basis.x
	
	#wigglewalking be damned!
	direction = direction.normalized()
	var step_accel = accel
	if !is_on_floor():
		step_accel *= air_multi
	
	#movement formula
	
	#value velocity is moving towards
	var target_vel = direction * top_speed
	velocity.x = move_toward(velocity.x, target_vel.x, step_accel * delta)
	velocity.z = move_toward(velocity.z, target_vel.z, step_accel * delta)
	velocity.y -= grav * delta
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			jump()
		elif air_jump:
			velocity.x = 0
			velocity.z = 0
			jump()
			air_jump = false
		
	velocity = move_and_slide(velocity, Vector3.UP)
	
	
	
	

