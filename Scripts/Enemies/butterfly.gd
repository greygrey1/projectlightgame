extends Node2D
@export var p1 : Vector2
@export var p2: Vector2
@export var flip: bool
@onready var sprite = $AnimatedSprite2D
@onready var box = $Area2D
var touching = false
var startmove = false
var moving = false
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.flip_h = flip


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving == false:
		for i in box.get_overlapping_bodies().size():
			if box.get_overlapping_bodies()[i].is_in_group("Player"):
				touching = true
				startmove = true
				break
			else:touching = false
	if touching == false:
		if global_position.y == p1.y:
			var tween = create_tween()
			tween.tween_property(self, "global_position", Vector2(p1.x, p1.y -30), 3).set_trans(Tween.TRANS_CUBIC)
		elif global_position.y == p1.y - 30:
			var tween = create_tween()
			tween.tween_property(self, "global_position", Vector2(p1.x, p1.y), 3).set_trans(Tween.TRANS_CUBIC)
	else:
		if startmove == true:
			moving = true
			startmove = false
			await get_tree().create_timer(4).timeout
			print("moving", ", from: butterfly.gd L29")
			var tween = create_tween()
			await tween.tween_property(self, "global_position", p2, 5).set_trans(Tween.TRANS_CUBIC).finished
			await get_tree().create_timer(3).timeout
			tween = create_tween()
			await tween.tween_property(self, "global_position", p1, 5).set_trans(Tween.TRANS_CUBIC).finished
			moving = false
