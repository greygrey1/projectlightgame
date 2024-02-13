extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
var go : int = 0
var sqpos : int = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if go == 1:
		var velocity = Vector2()
		velocity.y = 10
		sqpos = velocity.y
		position.y = position.y + velocity.y
	






func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		go = 1

