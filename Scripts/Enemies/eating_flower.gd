extends Area2D
@onready var sprite = $AnimatedSprite2D
var eating : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	self.modulate = Color(1, 1, 1, 1)
	sprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("stag"):
		eating = true
		sprite.play("eat")
		
		await get_tree().create_timer(1).timeout
		var tween = self.create_tween()
		await tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1).finished
		queue_free()
		
	elif body.is_in_group("Player") and eating == false:
		sprite.play("eat")
		await get_tree().create_timer(0.3).timeout
		Phealth.h = 0
