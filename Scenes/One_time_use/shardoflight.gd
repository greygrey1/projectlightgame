extends RigidBody2D
var touched = false
signal collectedshard
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("Player") and touched == false:
		print("touchedme")
		touched = true
		emit_signal("collectedshard")
		await get_tree().create_timer(1).timeout
		queue_free()
