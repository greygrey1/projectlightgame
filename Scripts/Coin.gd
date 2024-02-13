extends Area2D

# You can change these to your likings
@export var amplitude := 4
@export var frequency := 5
@export var pos2 : Vector2
@export var stats: Resource
var time_passed = 0
var initial_position := Vector2.ZERO

func _ready():
	if stats:
		stats.skill = 1
		print(stats.skill)
	if pos2.x > 0 or pos2.x < 0:
		initial_position = pos2
	else:
		initial_position = position

func _process(delta):
	coin_hover(delta) # Call the coin_hover function

# Coin Hover Animation
func coin_hover(delta):
	time_passed += delta
	var new_y = initial_position.y + amplitude * sin(frequency * time_passed)
	position.y = new_y

# Coin collected
func _on_body_entered(body):
	if body.is_in_group("Player"):
		AudioManager.coin_pickup_sfx.play()
		GameManager.add_score()
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2.ZERO, 0.1)
		await tween.finished
		queue_free()
