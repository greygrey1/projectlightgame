extends CharacterBody2D

var hurting : int = 0
@onready var iframes = $iframes
var health : int = 3
@onready var crunch = $crunch
@onready var crunch2 = $crunch2
@onready var egg = $Sprite2D
@onready var anim = $anim
@onready var breakegg = $breakegg
@onready var part = $CPUParticles2D
@onready var eggbg = $Sprite2D2
@onready var eggtxt = $RichTextLabel3
@onready var wall = $RightWall
@onready var floor = $CollisionShape2D4
func __process(delta):
	if Saveload.load == 1:
		await Saveload.load == 0
		await get_tree().create_timer(0.5).timeout
		queue_free()
func _ready():
	part.emitting = false
	eggtxt.self_modulate = Color(1,1,1,1)
	eggbg.modulate = Color(1,1,1,1)
	egg.self_modulate = Color(1, 1, 1, 1)
	eggbg.self_modulate = Color(1,1,1,1)
	egg.play("start")
	if Saveload.load == 1:
		queue_free()

func _on_collision_area_entered(area):
	if area.is_in_group("slash") and hurting == 0:
		hurting = 1
		health = health - 1
		crunch.play()
		egg.play(str(health))
		egg.self_modulate = Color(255, 255, 255, 255)
		iframes.start()
		if health == 0:
			part.emitting = true
			crunch.play()
			crunch2.play(0.4)
			anim.play("fade egg")
			wall.queue_free()
			floor.queue_free()
			breakegg.start()
			await get_tree().create_timer(0.5).timeout
			part.emitting = false
		else:
			crunch.play()
			egg.self_modulate = Color(255, 255, 255, 255)
			


			


func _on_iframes_timeout():
	hurting = 0
	egg.self_modulate = Color(1, 1, 1, 1)


func _on_breakegg_timeout():
	queue_free()
