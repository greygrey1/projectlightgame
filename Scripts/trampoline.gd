extends Node2D

@onready var sprite = $Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("start")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	if area.is_in_group("Player"):
		sprite.stop()
		sprite.play("boing")
		AudioManager.trampoline.play()


func _on_sprite_2d_animation_finished():
	sprite.play("start")
