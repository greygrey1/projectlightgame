extends Area2D
@onready var timer = $Timer
@onready var timer2 = $Timer2
@onready var sprite = $AnimatedSprite2D
@onready var collision = $hit
@onready var timer3 = $Timer3
@onready var climb = $climbe/col
var vineme : int = 0
var offset2 
var offsetme = 0
var isfalling = 0
var playa : Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.vineshoot.play()
	look_at(global_position.direction_to(playa))
	print(playa)
	print("hh")
	collision.disabled = true
	climb.disabled = true
	sprite.play("default")
	timer.start()
func _draw():
	look_at(playa)
	offsetme = position.y
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if vineme >= 1: 
		Phealth.vine = 1
	else:
		Phealth.vine = 0


func _on_timer_timeout():
	collision.disabled = false
	sprite.play("fire")
	timer2.start()
	timer3.start()


func _on_timer_2_timeout():
	queue_free()

func _on_area_entered(area):
	if timer3.time_left > 0:
		if area.is_in_group("Player"):
			Phealth.knb = Vector2(randf_range(-1, 1), 0)
			print(Phealth.knb)
			Phealth.knockback = 1
			if Phealth.h > 1:
				Phealth.h = Phealth.h - 2
			else:
				Phealth.h = Phealth.h - 1
			AudioManager.dmgs.play()
			Phealth.vine = 0
			queue_free()
	else:
		pass


func _on_climbe_area_entered(area):
	if area.is_in_group("Player") and timer3.time_left == 0:
		vineme = vineme + 1


func _on_climbe_area_exited(area):
	if area.is_in_group("Player"):
		vineme = vineme - 1


func _on_timer_3_timeout():
	climb.disabled = false
	collision.disabled = true
