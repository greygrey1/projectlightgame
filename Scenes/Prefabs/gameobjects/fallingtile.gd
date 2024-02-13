extends CharacterBody2D
var falling: bool = false
var shaking: bool = false
@onready var sprite = $Sprite2D
@onready var falltimer = $falltimer
var reg
var startingpos : Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	startingpos = global_position
	reg = randi_range(0, 1)
	if reg == 1:
		sprite.region_rect = Rect2(128, 135, 16, 16)
	else: 
		sprite.region_rect = Rect2(162, 135, 16, 16)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if falltimer.time_left > 0:
		sprite.offset = Vector2(randi_range(-1, 1), randi_range(-1, 1))
	if falling == true:
		move_and_slide()
		velocity.y +=10

func _on_area_2d_area_entered(area):
	if area.is_in_group("Player"):
		falltimer.start()


func _on_falltimer_timeout():
	falling = true
	$returntimer.start()


func _on_returntimer_timeout():
	falltimer.stop()
	velocity.y = 0
	falling = false
	global_position = startingpos
