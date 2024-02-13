extends Area2D
@onready var ray = $RayCast2D
@onready var ray2 = $RayCast2D2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ray.is_colliding():
		position += Vector2(1, 0).rotated(rotation)
	else:
		self.rotation_degrees += 90
		
		


func _on_area_entered(area):
	if area.is_in_group("Player") and area.name == "Collision":
		Phealth.knb = Vector2(1, 0).rotated(rotation)
		Phealth.knockback = 1
		Phealth.damage()
