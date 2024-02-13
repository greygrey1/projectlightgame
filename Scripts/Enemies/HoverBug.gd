extends Node2D

@export var low : int
@export var high : int
@export var flip : bool
@onready var sprite = $Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	if flip == true:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	await get_tree().create_timer(0.3).timeout
	while true:
		var tween = self.create_tween()
		await tween.tween_property(self, "global_position", Vector2(self.global_position.x, low), 3).set_trans(Tween.TRANS_SINE).finished
		tween = self.create_tween()
		await tween.tween_property(self, "global_position", Vector2(self.global_position.x, high), 3).set_trans(Tween.TRANS_SINE).finished

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
