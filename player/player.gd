extends KinematicBody


export var speed = 10
export var acceleration = 5
export var gravity = 1
export var aircontrol = 0
export var jump_power = 0
export var mouse_sensitivity = 0.3
export var mouse_limit = 0

onready var head = $Head
onready var camera = $Head/Camera

onready var beam = $Head/Hand/Beam
onready var laser = $Head/Hand/Laser
onready var plasma = $Head/Hand/Plasma

var weapon = 1

var velocity = Vector3()
var camera_x_rotation = 0


# Basic mouse look 
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
	
	
func _input(event):
	if event is InputEventMouseMotion:
		# X-axis (turns around y-axis)
		head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		
		# Y-axis (turns around x-axis)
		var x_delta = event.relative.y * mouse_sensitivity
		if camera_x_rotation + x_delta > -mouse_limit and camera_x_rotation + x_delta < mouse_limit:
			camera.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta




# Basic player movemenet (forward, backward, left, right)
func _physics_process(delta):
	weapon_select()
	
	var head_basis = head.get_global_transform().basis
	
	var direction = Vector3()
	if Input.is_action_pressed("move_forward"):
		direction -= head_basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += head_basis.z
		
	if Input.is_action_pressed("move_left"):
		direction -= head_basis.x
	elif Input.is_action_pressed("move_right"):
		direction += head_basis.x
		
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	
	# Gravity and jump
	velocity.y -= gravity
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y += jump_power

	velocity = move_and_slide(velocity, Vector3.UP)
	



# Weaponselect
func weapon_select():
	if Input.is_action_just_pressed("weapon_next"):
		if weapon < 3:
			weapon += 1
		else:
			weapon = 1
	elif Input.is_action_just_pressed("weapon_previous"):
		if weapon > 1:
			weapon -= 1
		else:
			weapon = 3

	if weapon == 1:
		beam.visible = true
		beam.shoot()
	else:
		beam.visible = false
		
	if weapon == 2:
		laser.visible = true
		laser.shoot()
	else:
		laser.visible = false
		
	if weapon == 3:
		plasma.visible = true
		plasma.shoot()
	else:
		plasma.visible = false
