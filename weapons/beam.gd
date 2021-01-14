extends MeshInstance

export var rate = 0.1
export var ammo = 100
export var damage = 25

onready var hud_ammo = $"/root/World/Hud/Ammo"
onready var raycast = $"/root/World/Player/Head/Camera/RayCast"
onready var muzzle = $"/root/World/Player/Head/Hand/Beam/Muzzle"

func _ready():
	pass
	
func shoot():
	hud_ammo.text = str(ammo)
	
	if Input.is_action_just_pressed("fire"):
		if ammo > 0:
			print("Beam fired")
			check_collision()
			ammo -= 1
			yield(get_tree().create_timer(rate), "timeout")
		else:
			print("No ammo")

func check_collision():
	if raycast.is_colliding():
		var bullet = get_world().direct_space_state
		var collision = bullet.intersect_ray(muzzle.transform.origin, raycast.get_collision_point())
		
		if collision:
			var target = collision.collider
			if target.is_in_group("Targets"):
				print("Hit")
				target.health -= damage
