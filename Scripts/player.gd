extends CharacterBody2D

# --------- VARIABLES ---------- #

@export_category("Player Properties") # You can tweak these changes according to your likings
@export var move_speed : float = 150
@export var jump_force : float = 600
@export var gravity : float = 30
var walltouching
@export var max_jump_count : int = 2
var jump_count : int = 2
@onready var player = self
@export var dash_speed : float = 0
@export var dash_time : int = 0
@export var dash2_speed : float = 0
@export_category("Toggle Functions") # Double jump feature is disable by default (Can be toggled from inspector)
@export var double_jump : = false
@export var isDashingUp : int = 0
@export var canDash : int = 1
@export var feetDelay : int = 1
@export var dir : float = 0.0
var is_grounded : bool = false
@onready var coyote = $Timer
@onready var player_sprite = $AnimatedSprite2D
@onready var spawn_point = %SpawnPoint
@onready var particle_trails = $ParticleTrails
@onready var death_particles = $DeathParticles
@onready var dash_trails = $ParticleTrails2
@onready var dash_ghost = $DashGhost
@onready var slash = $Slash/slashTimer
@onready var deathsound1 = $deathsound1
@onready var deathsound2 = $deathsound2
@onready var anim = $AnimationPlayer
var facing : float = 1
var slashing : int = 0
var slashboost : int = 0
var save_pos = "user://score.save"
var save_scene = "user://scene.save"
@onready var spawnpoint2 = %SpawnPoint2
@onready var check = %checkpoint/AnimatedSprite2D
@onready var check2 = $Checkaim
@onready var canmove = 1
var trampoline = 0
var gumgum : int = 0
var slash2_speed 
var temtime
@onready var cam = $Camera2D
@onready var sseed : PackedScene
@onready var seedc = $SeedCooldown
@onready var scenetimer = %SceneSwitchTimer
var wall_jumps = 0

# --------- BUILT-IN FUNCTIONS ---------- #
func _ready():
	if ResourceLoader.exists("checkpoint"):
		check.play("put_out")
	anim.play("reset")
	check2.play("Gamesaved")
	if Saveload.load == 1:
		global_position = Saveload.goto
	temtime = get_tree().create_timer(0.5)


func _physics_process(_delta):
	# Calling functions
	checkhealth()
	if canmove == 1:
		if !scenetimer.time_left > 0: realmove()
		movement()
		player_animations()
		flip_player()
		handle_dashing()
		handle_slashing()
		check_vine()
		check_save()
		handle_seed()

	else:
		velocity.x = 0
		player_animations()
		velocity.y += gravity
	if Saveload.load == 1:
		
		await get_tree().create_timer(0.45).timeout
		global_position = Saveload.goto
		Saveload.load = 0
# --------- CUSTOM FUNCTIONS ---------- #
func checkhealth():
	if Phealth.h == 0:
		death_tween2()
func check_save():
	if Input.is_action_just_pressed("Load"):
		Saveload.loadgame()
		await get_tree().create_timer(0.5).timeout
		global_position = Saveload.goto
		print(Saveload.goto)
		print("ahhh")
	
# <-- Player Movement Code -->
func handle_slashing():
	
	if player_sprite.flip_h == false:
		facing = 1
	elif player_sprite.flip_h == true:
		facing = -1

	
	if !slash.is_stopped() and slashing == 0:
		slashing = 1
		slashboost = 200
		var inputAxis = Input.get_axis("Left", "Right")
		dir = facing * -808
		slash2_speed = -200
	if slash.is_stopped() and Phealth.knockback == 0:
		slashing = 0
		slash2_speed = 0
	if Phealth.knockback == 1:
		dir = Phealth.knb.x * 800
		if Phealth.knb.y !=0:
			slash2_speed = Phealth.knb.y
		else:
			slash2_speed = -200
		Phealth.knockback = 0
	if trampoline == 1:
		if slash2_speed > 0:
			if slash2_speed > 600:
				slash2_speed = slash2_speed - 200
			else:
				slash2_speed = slash2_speed - 50
		else:
			slash2_speed = -1000
		if temtime.time_left == 0:
			check2.play
			temtime = get_tree().create_timer(0.2)
			await temtime.timeout
			trampoline = 0
			slash2_speed = 0


func realmove():
	if Input.is_action_pressed("Left") or dir > 252:
		if dir > -252:
			if dir > 0:
				dir = dir - 13
			if get_wall_normal() == Vector2(1, 0) and is_on_floor():
				dir = dir - 13
			dir = dir - 13
	if Input.is_action_pressed("Right") or dir < -252:
		if dir < 252:
			if dir < 0:
				dir = dir + 13
			if get_wall_normal() == Vector2(-1, 0) and is_on_floor():
				dir = dir + 13
			dir = dir + 13
	if !Input.is_action_pressed("Right") and !Input.is_action_pressed("Left"):
		if is_on_floor():
			if dir > 0:
				dir = dir - 13
			if dir < 0:
				dir = dir + 13
			if dir < 13 and dir > -13:
				dir = 0
func movement():

	handle_jumping()
	
	# Gravity
	if dash_time > 0:
		dash_ghost.emitting = true
		dash_speed = 500
		dash_time = dash_time - 1
		dash2_speed = -500 * isDashingUp
	elif dash_time == 0:
		dash_speed = 0
		dash2_speed = 0
		dash_ghost.emitting = false

	if !is_on_floor():
		if dash_time == 0 and slashing == 0 and trampoline == 0 and !scenetimer.time_left > 0:
			if cam.position_smoothing_enabled == true:
				velocity.y += gravity
			elif !scenetimer.time_left > 0:
				if velocity.y < 1000:
					velocity.y += gravity
				else:
					if Input.is_action_pressed("Jump"):
						velocity.y = 900
						Phealth.off = Phealth.off + 1
					if Input.is_action_pressed("Down"):
						velocity.y = 1100
						Phealth.off = Phealth.off - 1
					else:
						velocity.y = 1000
		elif !scenetimer.time_left > 0:
			velocity.y = dash2_speed * isDashingUp + slash2_speed 
	elif is_on_floor():
		jump_count = max_jump_count
		canDash = 1
		if velocity.y ==0:
			velocity.y = slash2_speed
	if canmove == 0:
		velocity.y += gravity
	
	# Move Player
	var inputAxis = Input.get_axis("Left", "Right")
	var isJumping = Input.is_action_just_pressed("Jump")
	if canmove == 1:
		velocity = Vector2(dir + (inputAxis * dash_speed), velocity.y)
	var was_on_floor = is_on_floor()
	if not scenetimer.time_left > 0:
		move_and_slide()
	if was_on_floor && !is_on_floor():
		coyote.start()
	if !is_on_floor():
		feetDelay = 21
	if is_on_floor() and velocity.x != 0:
		if feetDelay > 20:
			$feet.play()
			feetDelay = 0
		else:
			feetDelay = feetDelay + 1
func handle_dashing():
	if Input.is_action_just_pressed("Dash") and canDash == 1:
		dash()
func dash():
	if Input.get_axis("Left", "Right") or Input.is_action_pressed("Jump"):
		dash_speed = 500
		dash_time = 7
		isDashingUp = 0
		canDash = 0
		$AudioPlayy.play()
	if Input.is_action_pressed("Jump"):
		isDashingUp = 1
		dash2_speed = -500
		$AudioPlayy.play()
# Handles jumping functionality (double jump or single jump, can be toggled from inspector)
func handle_jumping():
	if is_on_floor_only():
		wall_jumps = 5
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor() and coyote.is_stopped():
			jump()
		elif double_jump and jump_count > 0:
			jump()
			jump_count -= 1
		elif is_on_wall_only() and walltouching == 1 and Phealth.invarray.has("walljump"):
			wall_jump()

# Player jump
func jump():
	jump_tween()
	AudioManager.jump_sfx.play()
	velocity.y = -jump_force

# Handle Player Animations
func player_animations():
	particle_trails.emitting = false
	dash_trails.emitting = false
	if canDash == 0 or dash_time > 0:
		player_sprite.play("Dash")
		dash_trails.emitting = true
	else:
		if is_on_floor():
			if abs(velocity.x) > 0:
				
				particle_trails.emitting = true
				player_sprite.play("Walk", 1.5)
			else:
				player_sprite.play("Idle")
		else:
			player_sprite.play("Jump")

# Flip player sprite based on X velocity
func flip_player():
	var inputAxis = Input.get_axis("Left", "Right")
	if inputAxis < 0: 
		player_sprite.flip_h = true
	elif inputAxis > 0:
		player_sprite.flip_h = false

func death_tween2():
	deathsound2.play()

	anim.play("deathanim")
	death_tween()
# Tween Animations
func death_tween():

	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.15)
	await tween.finished
	global_position = spawn_point.global_position
	await get_tree().create_timer(0.3).timeout
	get_tree().call_group("manager", "timesave")
	AudioManager.respawn_sfx.play()
	respawn_tween()
func soundplay():
	pass
func respawn_tween():
	var tween = create_tween()
	deathsound1.play()
	tween.stop(); tween.play()
	tween.tween_property(self, "scale", Vector2.ONE, 0.15) 


func jump_tween():
	var tween = create_tween()
	tween.tween_property(player_sprite, "scale", Vector2(2.8, 5), 0.1)
	tween.tween_property(player_sprite, "scale", Vector2(4.12, 4.12), 0.1)

# --------- SIGNALS ---------- #

# Reset the player's position to the current level spawn point if collided with any trap
func _on_collision_body_entered(_body):
	if _body.is_in_group("Traps") or _body.is_in_group("enemies"):
		AudioManager.death_sfx.play()
		death_particles.emitting = true
		Phealth.h = 0
		GameManager.reset_scene()
	
		




func _on_checkpoint_area_entered(area):
	if area.is_in_group("Player"):
		var checkreach = $Checkaim
		if SceneTransition.scene_num == 0 and global_position.x > 200:
			spawn_point = spawnpoint2
		elif SceneTransition.scene_num == 0 and global_position.x < 200:
			spawn_point = %SpawnPoint
		elif SceneTransition.scene_num == 1:
			spawn_point = %SpawnPoint
		elif SceneTransition.scene_num == 3:
			spawn_point = %SpawnPoint
			if position.x > 228 and position.x < 8000:
				spawn_point.global_position = Vector2(4717, 438)
			elif position.x > 8100:
				spawn_point.global_position = Vector2(8227, -2130)
			else:
				spawn_point.global_position = Vector2(151, 428)
		elif SceneTransition.scene_num == 4:
			spawn_point = %SpawnPoint
		check.play("burning")
		AudioManager.firewhoosh.play()
		if !check.is_playing():
			checkreach.play("checkpoint")
			await get_tree().create_timer(2).timeout
			checkreach.play("checkpointend")
		else:
			checkreach.play("Gamesaved")
		print("this is spawn")
		print(spawn_point)
		print(spawn_point.global_position)
		Saveload.savegame(spawn_point.global_position)

func check_vine():
	Phealth.vine = 0
	for i in $Collision.get_overlapping_areas().size():
		if $Collision.get_overlapping_areas()[i].is_in_group("vine"):
			Phealth.vine = 1
			print("hi")
			break
	if Phealth.vine == 1:
		if Input.is_action_pressed("Jump"):
			velocity.y = -200
			jump_force = 0
			gravity = 0
		else:
			jump_force = 0
			gravity = 30
	else:
		gravity = 30
		jump_force = 600
func _on_area_2d_area_entered(area):
	if area.is_in_group("Player"):
		pass
		#Phealth.vine = 1
		
func handle_seed():
	if Input.is_action_just_pressed("seed") and SceneTransition.scene_num >= 4 and seedc.time_left == 0:
		seedc.start()
		shoot_seed()
func shoot_seed():
	print("shooting seed")
	sseed = load("res://Scenes/Prefabs/silver_seed.tscn")
	var s = sseed.instantiate()
	owner.add_child(s)
	s.global_position.x = self.global_position.x
	s.global_position.y = self.global_position.y
	s.facedir = facing

func _on_area_2d_area_exited(area):
	if area.is_in_group("Player"):
		Phealth.vine = 0
		gravity = 30
		jump_force = 600   


func _on_trampoline_area_entered(area):
	if area.is_in_group("Player"):
		trampoline = 1
		canDash = 1
		wall_jumps = 5


func wall_jump():
	print(platform_wall_layers)
	wall_jumps -= 1
	if wall_jumps > 0:
		if get_wall_normal() == Vector2(1, 0):
			velocity.y = -jump_force
			dir = 400
		if get_wall_normal() == Vector2(-1, 0):
			velocity.y = -jump_force
			dir = -400
		


func _on_collision_2_body_entered(body):
	if body.is_in_group("Ground"):
		walltouching = 1


func _on_collision_2_body_exited(body):
	if body.is_in_group("Ground"):
		walltouching = 0


func _on_collision_area_entered(area):
	if area.is_in_group("PKers"):
		AudioManager.death_sfx.play()
		death_particles.emitting = true
		Phealth.h = 0
		GameManager.reset_scene()


func launch():
	if is_on_floor():slash2_speed = -800
	shake()

func shake():
	for i in 10:
		cam.offset = Vector2(randi_range(-1, 1), randi_range(-1, 1))
		await get_tree().create_timer(0.01).timeout
	cam.offset = Vector2(0, 0)

func camshake(sh: int):
	for i in 10:
		cam.offset = Vector2(randi_range(-sh, sh), randi_range(-sh, sh))
		await get_tree().create_timer(0.01).timeout
	cam.offset = Vector2(0, 0)
