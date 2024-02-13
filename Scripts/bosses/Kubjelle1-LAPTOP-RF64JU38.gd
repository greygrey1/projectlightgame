extends Node2D
@onready var sprite = $Sprite
var health = 0
var positionsx
var positionsy
var waiting1
@onready var bulletdelay = $bulletdelay
@export var flowerbullet : PackedScene
@onready var Player = %Player
@onready var dmg = $damageanim
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("Idle")
	
	positionsx = [1132, 1549, 1900, 2100, 2900, 4340, 5550, 5420, 6370, 5285, 6767, 7980, 6496, 7900, 8514, 8844, 9195, 8507, 8844, 9191]
	positionsy = [420, 420, 420, 100, 160, 160, 708, 160, -440, -970, -1110, -1388, -1927, -2129, -2400, -2667, -2398, -2804, -2667, -2601]
	waiting1 = [100, 3, 1, 2, 2, 2, 3, 3,3, 3, 3, 3, 3, 3, 2, 2, 1, 1, 1, 1, 0.5, 0.5,]
	position = Vector2(positionsx[health], positionsy[health])
	bulletdelay.wait_time = waiting1[health]
	bulletdelay.wait_time = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if bulletdelay.is_stopped():
		bulletdelay.start()
	if Phealth.h == 0:
		if health > 5:
			health = 6
		else:
			health = 0
		position = Vector2(positionsx[health], positionsy[health])
		bulletdelay.wait_time = waiting1[health]
	
	



func _on_area_2d_area_entered(area):
	if area.is_in_group("slash"):
		health = health + 1
		print(health)
		sprite.stop()
		sprite.play("Down")
		dmg.play("damaged")
		AudioManager.dmgs.play()
		Phealth.heal()
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
