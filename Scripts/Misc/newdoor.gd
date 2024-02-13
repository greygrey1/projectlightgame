extends StaticBody2D

var opentime
var opening = 0
var doors = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if opening == 1:
		if $opentimer2.time_left >= 0:
			position.y = position.y - 10
func open():
	AudioManager.coin_pickup_sfx.play()
	$opentimer.start()
	await $opentimer.timeout
	$opentimer2.start()
	opening = 1
