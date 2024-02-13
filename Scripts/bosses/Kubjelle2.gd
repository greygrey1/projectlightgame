extends Node2D

var velocity : Vector2
var firenum = 0
var health = 0 
var flowerbullet : PackedScene
@onready var Player = %Player 
@onready var inter = $FireInterval
@onready var timef = $Time2Fire
@onready var sprite = $Sprite2D
var rainbullet : PackedScene
var bcount 
@onready var text = %TextBox
@onready var kbhealth = %Kubjellhealth2
# Called when the node enters the scene tree for the first time.
func _ready():
	timef.wait_time = 5
	inter.wait_time = 0.4
	bcount = 5
	sprite.visible = false
	kbhealth.visible = false
	kbhealth.value = 10
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity
	if health == 10:
		text.textnum = 0
		health = health + 1
		sprite.visible = true
		Player.canmove = 0
		text.cutscene = 3
		queue_free()
	if Phealth.final == 1 or Input.is_action_just_pressed("Debug"):
		kbhealth.visible = true
		Phealth.final = 0
		sprite.visible = true
		timef.start()
		velocity = Vector2(1.5, 1.5)


func _on_walls_area_entered(area):
	if area.is_in_group("DVD"):
		velocity.y = velocity.y * -1

func _on_cielingfloor_area_entered(area):
	if area.is_in_group("DVD"):
		velocity.x = velocity.x * -1
		
func mainshooter():
	if health < 5 and timef.is_stopped() and firenum == 0:
		timef.wait_time = 2
		inter.wait_time = 0.1
		bcount = 10
	if health < 2 and timef.is_stopped() and firenum == 0:
		timef.start()
		
func shoot():
	flowerbullet = load("res://Scenes/Prefabs/flowerbullet.tscn")
	var b = flowerbullet.instantiate()
	b.playa = Player.position
	owner.add_child(b)
	b.transform = self.global_transform


func _on_fire_interval_timeout():
	if firenum > 0:
		firenum = firenum - 1
		shoot()
		inter.start()
		print(firenum)
	else:
		mainshooter()
		


func _on_time_2_fire_timeout():
	print("newtimerended")
	inter.start()
	firenum = bcount


func _on_area_2d_area_entered(area):
	if area.is_in_group("slash"):
		Phealth.h = Phealth.h + 1
		var tween = create_tween()
		tween.tween_property(kbhealth, "value", 10 - health, 0.1)
		health = health + 1
		AudioManager.kubjellehurt.play()
		
func shoot2():
	rainbullet = load("res://Scenes/Prefabs/RainBullet.tscn")
	var b = rainbullet.instantiate()
	b.playa = Player.position
	self.add_child(b)
	b.position = Vector2(randf_range(-200, 200), -500)
