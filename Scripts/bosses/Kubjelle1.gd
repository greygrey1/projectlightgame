extends Node2D
@onready var sprite = $Sprite
var health = 0
var positionsx
var positionsy
var waiting1
@onready var bulletdelay = $bulletdelay
@onready var raindelay = $Raindelay
@export var flowerbullet : PackedScene
@onready var Player = %Player
@onready var dmg = $damageanim
@export var rainbullet : PackedScene
@onready var kbhealth = %Kubjellhealth
@onready var kbhealth2 = %Kubjellhealth2
var startme = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	kbhealth.visible = false
	kbhealth2.visible = false
	sprite.play("Idle")
	positionsx = [1132, 1549, 1900, 2100, 2900, 4340, 5550, 5420, 6370, 5285, 6767, 7980, 6496, 7900, 8514, 8844, 9195, 8854, 8844, 9191]
	positionsy = [420, 420, 420, 100, 160, 160, 708, 160, -440, -970, -1110, -1388, -1927, -2129, -2400, -2667, -2398, -2467, -2667, -2601]
	waiting1 = [100, 3, 1, 2, 2, 2, 3, 3,3, 3, 3, 3, 3, 3, 2, 2, 1, 1, 1, 1, 0.5, 0.5,]
	position = Vector2(positionsx[health], positionsy[health])
	bulletdelay.wait_time = waiting1[health]
	bulletdelay.wait_time = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if AudioManager.whichmusic == 3 and startme == 0: 
		kbhealth.visible =  true
		kbhealth.value = 0
		var tween = create_tween()
		await tween.tween_property(kbhealth, "value", 20, 1).finished
		startme = 1
	if bulletdelay.is_stopped():
		bulletdelay.start()
	if Phealth.h == 0:
		if health > 5 and health < 9:
			health = 6
		elif health >= 9 and health < 11:
			health = 9
		elif health >= 11 and health < 14:
			health = 11
		elif health > 13:
			health = 14
		else:
			health = 0
		position = Vector2(positionsx[health], positionsy[health])
		bulletdelay.wait_time = waiting1[health]
		
	if health > 2 and raindelay.time_left == 0:
		raindelay.start()
		
	
	
	

func debug():
	await get_tree().create_timer(0.05).timeout
	position = Vector2(positionsx[health], positionsy[health])
	bulletdelay.wait_time = waiting1[health]

func _on_area_2d_area_entered(area):
	if area.is_in_group("slash"):
		Player.canDash = 1
		health = health + 1
		print(health)
		var tween = create_tween()
		tween.tween_property(kbhealth, "value", 20 - health, 0.1)
		sprite.stop()
		sprite.play("Down")
		dmg.play("damaged")
		AudioManager.kubjellehurt.play()
		Phealth.heal()
		if health == 20:
			Phealth.timetogo = 1
			Phealth.final = 1
			kbhealth.visible = false
			kbhealth2.visible = true
			queue_free()
		await get_tree().create_timer(0.3).timeout
		position = Vector2(positionsx[health], positionsy[health])
		bulletdelay.wait_time = waiting1[health]
		bulletdelay.start()
		sprite.play("Up")
		await get_tree().create_timer(0.6).timeout
		sprite.play("Idle")
		



func _on_bulletdelay_timeout():
	shoot()
	
func shoot():
	flowerbullet = load("res://Scenes/Prefabs/flowerbullet.tscn")
	var b = flowerbullet.instantiate()
	b.playa = Player.position
	owner.add_child(b)
	b.transform = self.global_transform

func shoot2():
	rainbullet = load("res://Scenes/Prefabs/RainBullet.tscn")
	var b = rainbullet.instantiate()
	b.playa = Player.position
	self.add_child(b)
	b.position = Vector2(randf_range(-200, 200), -500)



func _on_raindelay_timeout():
	shoot2()
	

