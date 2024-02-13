extends Node2D

@onready var slash = $Area2D/CollisionShape2D
@onready var slashsprite = $Area2D/Sprite2D
@onready var slashTimer = $slashTimer
@onready var cooldown = $slashCooldown
@onready var sound = $AudioStreamPlayer2D
@onready var sword = $sword
@onready var swordswing = $swordswing
var slashing : int = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	slash.disabled = true
	sword.visible = false
	slashsprite.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Slash") and cooldown.is_stopped() and slashTimer.is_stopped:
		slashTimer.start()
		sound.play()
		slash.disabled = false
		slashsprite.visible = true
		sword.visible = true
		cooldown.start()
		if sword.flip_h == true:
			swordswing.play("swing2")
			sword.offset.x = -30
		elif sword.flip_h == false:
			swordswing.play("swing")
			sword.offset.x = 35
		slashsprite.play()
			
		
		
	if Input.is_action_just_pressed("Right") and slashTimer.is_stopped():
		position.x = 50
		sword.position.x = -51.165
		slashsprite.flip_h = true
		sword.flip_h = false
		
		
	if Input.is_action_just_pressed("Left") and slashTimer.is_stopped():
		position.x = -50
		sword.position.x = 51
		slashsprite.flip_h = false
		sword.flip_h = true
		
		


func _on_area_2d_body_entered(body):
	if body.is_in_group("enemies"):
		print("SMASH")


func _on_slash_timer_timeout():
	slashsprite.stop()
	slashing = 0
	slash.disabled = true
	slashsprite.visible = false
	sword.visible = false

