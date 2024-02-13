extends CharacterBody2D

# --------- VARIABLES ---------- #

@export_category("Player Properties") # You can tweak these changes according to your likings
@export var move_speed : float = 150
@export var jump_force : float = 600
@export var gravity : float = 30
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
var gumgum : int = 0

# --------- BUILT-IN FUNCTIONS ---------- #
func _ready():
	check.play("put_out")


func _process(_delta):
	# Calling functions
	realmove()
	movement()
	player_animations()
	flip_player()
	handle_dashing()
	handle_slashing()
	check_vine()
	check_save()
# --------- CUSTOM FUNCTIONS ---------- #
func check_save():
	if Input.is_action_just_pressed("Load"):
		Saveload.load()
	
# <-- Player Movement Code -->
func handle_slashing():
	
	if Input.is_action_just_pressed("Right"):
		facing = 1
	if Input.is_action_just_pressed("Left"):
		facing = -1

	
	if !slash.is_stopped() and slashing == 0:
		slashing = 1
		slashboost = 200
		var inputAxis = Input.get_axis("Left", "Right")
		dir = facing * -808
	if slash.is_stopped():
		slashing = 0



func realmove():
	if Input.is_action_pressed("Left") or dir > 202:
		if dir > -202:
			if dir > 0:
				dir = dir - 13
			dir = dir - 13
	if Input.is_action_pressed("Right") or dir < -202:
		if dir < 202:
			if dir < 0:
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
		if dash_time == 0 and slashing == 0:
			velocity.y += gravity 
		else:
			velocity.y = dash2_speed * isDashingUp 
	elif is_on_floor():
		jump_count = max_jump_count
		canDash = 1
	
	# Move Player
	var inputAxis = Input.get_axis("Left", "Right")
	var isJumping = Input.is_action_just_pressed("Jump")
	velocity = Vector2(dir + (inputAxis * dash_speed), velocity.y)
	var was_on_floor = is_on_floor()
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
	if Input.is_action_just_pressed("Jump"):
		if is_on_floor() and coyote.is_stopped():
			jump()
		elif double_jump and jump_count > 0:
			jump()
			jump_count -= 1

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
	tween.tween_property(self, "scale", Vector2(0.7, 1.4), 0.1)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)

# --------- SIGNALS ---------- #

# Reset the player's position to the current level spawn point if collided with any trap
func _on_collision_body_entered(_body):
	if _body.is_in_group("Traps") or _body.is_in_group("enemies"):
		AudioManager.death_sfx.play()
		death_particles.emitting = true
		death_tween2()
		GameManager.reset_scene()





func _on_checkpoint_area_entered(area):
	var checkreach = $Checkaim
	if SceneTransition.scene_num == 0:
		spawn_point = spawnpoint2
	elif SceneTransition.scene_num == 1:
		spawn_point = %SpawnPoint
	check.play("burning")
	AudioManager.firewhoosh.play()
	if !check.is_playing():
		checkreach.play("checkpoint")
		await get_tree().create_timer(2).timeout
		checkreach.play("checkpointend")
	else:
		checkreach.play("Gamesaved")
	print(spawn_point)
	var realspawn = spawn_point.global_position
	Saveload.save(spawn_point.global_position)


func check_vine():
	if gumgum == 1:
		if Input.is_action_pressed("Jump"):
			velocity.y = -100
			jump_force = 0
			gravity = 0
		else:
			jump_force = 0
			gravity = 30
func _on_area_2d_area_entered(area):
	gumgum = 1
		


func _on_area_2d_area_exited(area):
	gumgum = 0
	gravity = 30
	jump_force = 600   
