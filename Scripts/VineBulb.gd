extends Node2D

var touchingme = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if touchingme == 1 and Phealth.seed_count >= 1 and Input.is_action_just_pressed("testkey"):
		Phealth.seed_count = 0
		var vine : PackedScene
		vine = load("res://Scenes/Prefabs/vine.tscn")
		var b = vine.instantiate()
		self.add_child(b)
		b.global_position = self.global_position
		print(b.position)
		print("completed vine")

func _on_bulbarea_area_entered(area):
	if area.is_in_group("Player"):
		touchingme = 1


func _on_bulbarea_area_exited(area):
	if area.is_in_group("Player"):
		touchingme = 0
