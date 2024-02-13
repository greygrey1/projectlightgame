extends Node2D
@onready var sprite = $AnimatedSprite2D
@onready var shader = $BackBufferCopy/TextureRect.material
var chrspread = 0.0
var chroming = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	shader.set("shader_parameter/spread", chrspread)
	if sprite.frame == 15 and sprite.animation == "idle" and chroming == false:
		chroming = true
		var tween2 = create_tween()
		var tween = create_tween()
		tween2.tween_property(sprite, "scale", Vector2(6.0, 6.0), 0.1)
		await tween.tween_property(self, "chrspread", 0.05, 0.2).finished
		tween2 = create_tween()
		tween = create_tween()
		tween2.tween_property(sprite, "scale", Vector2(5.5, 5.5), 0.5)
		await tween.tween_property(self, "chrspread", 0.015, 3).finished
		chroming = false
		
