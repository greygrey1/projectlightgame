extends Node2D
@export var knocking : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if $Area2D/CollisionShape2D.disabled == false:
		if body.is_in_group("seed"):
			if body.canparry == 1:
				body.parry()
				AudioManager.parry()
		elif body.is_in_group("Player"):
			Phealth.knockback = 1
			Phealth.knb = knocking
