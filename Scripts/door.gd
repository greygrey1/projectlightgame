extends CharacterBody2D
var opentime
var opening
var doors = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	opening = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if opening == 1:
		if opentime.time_left >= 0:
			position.y = position.y - 10


func _on_door_button_body_entered(body):
	if body.is_in_group("button activator"):
		if self.name == "CH2" and doors > 1:
			open()
			doors += 1
		elif self.name == "CharacterBody2D" and doors == 0:
			doors +=1
			open()
		
func open():
	AudioManager.coin_pickup_sfx.play()
	await get_tree().create_timer(1).timeout
	opentime = get_tree().create_timer(1)
	opening = 1
