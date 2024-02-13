extends Node2D
var player
var goto
var gotop
# Called when the node enters the scene tree for the first time.
func _ready():
	gotop = player.global_position
	goto = create_tween()
	goto.tween_property(self, "global_position", gotop, 1)
	AudioManager.sound("splode1.wav")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Timer.time_left >0.8 and $Timer.time_left < 0.9:
		player.shake()
		AudioManager.sound("splode2.wav")


func _on_timer_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		Phealth.damage()
