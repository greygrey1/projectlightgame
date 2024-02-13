extends Area2D

@export var dir : Vector2
var readyy : bool = false
var dir2
@export var speed : int
var parried : int = 0
@onready var player = %Player
# Called when the node enters the scene tree for the first time.
func _ready():
	await self.NOTIFICATION_PARENTED
	readyy = true
	self.look_at(dir2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if readyy == true:
		global_position += dir*speed


func _on_body_entered(body):
	if body.is_in_group("seed"):
		if body.canparry ==1:
			parried = 1
			body.parry()
			Phealth.knb = dir
			Phealth.knockback = 1
			AudioManager.parry()
			dir = Vector2(0, 0)
			Engine.time_scale = 0.1
			await get_tree().create_timer(0.05).timeout
			print("parried")
			get_tree().get_first_node_in_group("Player").shake()
			Engine.time_scale = 1
			await get_tree().create_timer(0.3).timeout
			queue_free()
	elif body.is_in_group("Ground") and parried == 0:
		print("hit wall")
		dir = Vector2(0, 0)
		await get_tree().create_timer(1).timeout
		queue_free()
	elif body.is_in_group("Player") and parried ==0:
		await get_tree().create_timer(0.1).timeout
		
		AudioManager.dmgs.play()
		Phealth.h-=1
		Phealth.knockback = 1
		await get_tree().create_timer(0.4).timeout
		queue_free()
	
