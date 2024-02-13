extends CharacterBody2D


@onready var go : int = 1
@onready var flip : int = 0
@onready var wolf = $AnimatedSprite2D
@onready var health : int = 3
@onready var damaging : int = 0
@onready var iframes = $WolfFrames
@onready var crunch = $AudioStreamPlayer2D
@onready var hittimer = $WolfHit
@onready var deathsound = $AudioStreamPlayer2D2
@onready var cankill = $CollisionShape2D
@onready var transparency : int = 255
@onready var player = $AnimatedSprite2D/AnimationPlayer
@onready var Player = %Player
var localpos = global_position
var base = get_modulate()
func _on_detection_body_entered(body):
	if body.is_in_group("Player"):
		go = 1

func _ready():
	wolf.play("default")
	localpos = global_position
func _process(delta):
	if flip == 0:
		if position.x >= 0:
			wolf.flip_h = false
			position.x = position.x - 2
		else:
			flip = 1
	if flip == 1:
		if position.x < 400:
			wolf.flip_h = true
			position.x = position.x + 2
		else:
			flip = 0
	if GameManager.reset == 1:
		velocity.y = 0
		go = 0
		position.x = 0
		position.y = 0
		health = 3
		GameManager.reset = 0

	



	

func _on_collision_body_entered(_body):
	if _body.is_in_group("slash"):
		pass


func _on_collision_area_entered(area):
	if area.is_in_group("slash") and damaging == 0:
		health = health - 1
		damaging = 1
		iframes.start()
		crunch.play()
		base = get_modulate()
		modulate = Color(255,255,255,50)	
		hittimer.start()
	
		


func _on_wolf_frames_timeout():
	if health > 0:
		damaging = 0


func _on_wolf_hit_timeout():
	
	if health == 0:
		health = health - 1
		var coini : PackedScene
		coini = load("res://Scenes/Prefabs/Coin.tscn")
		var b = coini.instantiate()
		b.global_position = Vector2(self.global_position.x, self.global_position.y)
		b.pos2 = Vector2(self.global_position.x, self.global_position.y )
		owner.add_child(b)
		print(b.position.y)
		print(self.global_position.y)
		deathsound.play()
		cankill.disabled = false
		modulate = base
	elif health > 0:
		modulate = base
		
	elif health < 0:
		player.play("new_animation")
		wolf.stop()
		
	if deathsound.get_playback_position() > 1:
		queue_free()


