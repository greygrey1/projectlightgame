extends Area2D
var dir 
var speed = 5
@export var playa = Vector2()
var velocity : Vector2
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	velocity.y = 1
	timer.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	dir = playa - position
	position.y += velocity.y * speed
	if GameManager.reset == 1:
		queue_free()

func _on_timer_timeout():
	queue_free()


func _on_area_entered(area):
	if area.is_in_group("Player") and area.name == "Collision":
		Phealth.knb = velocity
		print(Phealth.knb)
		Phealth.knockback = 1
		Phealth.h = Phealth.h - 1
		AudioManager.dmgs.play()
		queue_free()
