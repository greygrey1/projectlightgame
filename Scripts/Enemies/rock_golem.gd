extends CharacterBody2D
@export var has_ai : bool = true
var playerpos : Vector2
var playerdir
@onready var sprite = $AnimatedSprite2D
var walking = true
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("swing")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	playerpos = get_parent().find_child("Player").global_position
	playerdir = global_position.direction_to(playerpos)
	if has_ai == true:
		if walking == true and not sprite.animation == "walk":
			sprite.play("walk")
		move_and_slide()
		velocity.y = 10
		if playerdir.x > 0:
			if walking == true:
				velocity.x = 10
			sprite.scale = Vector2(4,4)
			sprite.flip_v = false
		elif playerdir.x < 0:
			if walking == true:
				velocity.x = -10
			sprite.flip_v = true
			sprite.scale = Vector2(-4,-4)


func _on_damage_sensor_body_entered(body):
	if body.is_in_group("Player"):
		walking = false
		sprite.play("swing")
		await sprite.animation_finished
		walking = true
