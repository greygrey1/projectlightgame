extends CharacterBody2D
@onready var ray = $ShapeCast2D
@onready var player = %Player
@onready var delay = $Timerr
@onready var sprite = $Sprite2D
var canmove : bool = true
var running
var speed : Vector2 = Vector2(-1, 0)
# Called when the node enters the scene tree for the first time.
func _ready():
	flip_check()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.reset == 1:
		await get_tree().create_timer(0.5).timeout
		flip_check()
		running = 0
		velocity.x = 0
		position.x = 0
		position.y = 0 
	if delay.time_left > 0:
		sprite.self_modulate = Color(1, 0.3, 0.3)
	else:
		sprite.self_modulate = Color(1, 1, 1)

func _physics_process(delta):
	if ray.is_colliding() and delay.time_left == 0:
		if ray.get_collider(0).is_in_group("Player"):
			delay.start()
	if !is_on_floor():
		velocity.y += 30
		move_and_slide()
	else:
		velocity.y = 0
	if running == 1 and canmove == true:
		sprite.self_modulate = Color(1, 0.3, 0.3)
		move_and_slide()
		speed.x  = -10
		if sprite.flip_h == false:
			velocity.x = -600
		else:
			velocity.x = 600
		if is_on_wall():
			running = 0
			
			position.x = position.x + velocity.x/100 * -1
			velocity.x = 0
			flip()

func _on_timer_timeout():
	running = 1
func flip():
	if sprite.flip_h == false:
		$Area2D/CollisionShape2D.position.x = -52
		ray.target_position = Vector2(571, 0)
		sprite.flip_h = true
	elif sprite.flip_h == true:
		$Area2D/CollisionShape2D.position.x = 52
		ray.target_position = Vector2(-571, 0)
		sprite.flip_h = false
func flip_check():
	if owner.scale.x > 1:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	if sprite.flip_h == false:
		ray.target_position = Vector2(-571, 0)
	else:
		ray.target_position = Vector2(571, 0)


func _on_area_2d_area_entered(area):
	if area.is_in_group("cankillstag"):
		canmove = false
		running = 0
		var tween = self.create_tween()
		tween.tween_property(sprite, "scale", Vector2(0.1, 0.1), 0.5)
		await get_tree().create_timer(1).timeout
		queue_free()
