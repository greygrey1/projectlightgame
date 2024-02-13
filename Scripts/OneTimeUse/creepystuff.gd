extends Node2D
@onready var Player = %Player
@onready var area = $Area2D
@onready var tex = $BackBufferCopy/TextureRect
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tex.material.set("shader_parameter/alph", 1-clamp(self.global_position.distance_to(Player.global_position)/43/100, 0, 1))
	for i in area.get_overlapping_bodies().size():
		if area.get_overlapping_bodies()[i].is_in_group("Player"):
			self.visible = true
			break
		else:
			self.visible = false
		
