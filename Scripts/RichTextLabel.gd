extends RichTextLabel
@onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	self_modulate = Color(1, 1, 1, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		anim.play("fadein")


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		anim.play("textfade")
