extends CharacterBody2D
@export var facedir :  float
@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D
var canparry: int = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("base")
	await get_tree().create_timer(0.3).timeout
	canparry = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_slide()
	velocity.x = 300 * facedir
	if velocity.x >= 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	if is_on_wall():
		anim.play("fadeout")
		velocity.x = 0
		await get_tree().create_timer(0.4).timeout
		queue_free()

func parry():
	facedir = 0
	var tween = create_tween()
	await tween.tween_property($Sprite2D2, "scale", Vector2(20, 20), 0.05).set_trans(Tween.TRANS_CUBIC).finished
	tween = create_tween()
	await tween.tween_property($Sprite2D2, "scale", Vector2(1, 1), 0.02).set_trans(Tween.TRANS_CUBIC).finished
	tween = create_tween()
	Phealth.heal()
	await tween.tween_property($Sprite2D2, "scale", Vector2(200, 20), 0.04).set_trans(Tween.TRANS_CUBIC).finished
	anim.play("fadeout")
	tween = create_tween()
	tween.tween_property($Sprite2D2, "modulate", Color("ffffff", 0), 0.4)
	await get_tree().create_timer(0.4).timeout
	queue_free()
	
	

