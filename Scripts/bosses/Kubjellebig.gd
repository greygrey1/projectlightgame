extends Node2D
@onready var anim = $AnimationPlayer
@onready var Player = %Player
var vine : PackedScene
@onready var timer = $Timer
@onready var timer2 = $Timer2
var rainbullet : PackedScene
var flowerbullet : PackedScene
var health = 20
@onready var sprite = $Sprite2D
@onready var tiles = %TileMap
@onready var timer3 = $Timer3
@onready var timer4 = $Timer4
@onready var timer5 = $Timer5
@onready var camlimit = %Camera2D
@onready var kbhealth = %Kubjellhealth3
@onready var splode = %splodepart
var end2 :int = 0
var health2 = 0
var b
var ending = 0
var facedirection : Vector2
@onready var credits = $"Credits things"
@onready var swordsprite = $Sprite2D2

# Called when the node enters the scene tree for the first time.
func _ready():
	swordsprite.visible = false
	credits.visible = false
	kbhealth.value = 0
	var tween = create_tween()
	tween.tween_property(kbhealth, "value", 20, 1)
	self.rotation_degrees = self.rotation_degrees + 1
	anim.stop()
	anim.play("KubjelleIdle")
	anim.play("idle2")
	timer.start()
	tiles.position.x = 1
	camlimit.limit_bottom = 730
	camlimit.position_smoothing_enabled = true
	Player.gravity = 30
	camlimit.limit_left = -205
	camlimit.limit_right = 1370

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	swordsprite.rotation_degrees = sprite.rotation_degrees - 200
	facedirection = Vector2(sin(sprite.rotation) * 6, cos(sprite.rotation) * 6)
	if timer2.time_left == 0 and health > 1:
		timer2.start()
	if health < 15 and timer3.time_left == 0 and health > 1:
		timer3.start()
	if health == 0:
		pass
	if health == 1:
		timer.stop()
		timer2.stop()
		timer3.stop()
		timer.wait_time = 0
		timer2.wait_time = 0
		timer3.wait_time = 0
		anim.pause()
		AudioManager.whichmusic = 0
		sprite.rotation_degrees = sprite.rotation_degrees + 1
	else:
		sprite.rotation_degrees = sprite.rotation_degrees + 1
	if health <= 1 and health > 0 and ending == 1:
		anim.stop()
		tiles.position.x = -3000
		camlimit.limit_bottom = 60000
		AudioManager.whichmusic = 5
		camlimit.position_smoothing_enabled = false
		position.x = camlimit.global_position.x - 100
		position.y = camlimit.global_position.y + 200 + camlimit.offset.y
		camlimit.offset.y = Phealth.off
		if Engine.time_scale == 1:
			camlimit.offset.x = randf_range(-10, 10)
			camlimit.offset.y = camlimit.offset.y + randf_range(-10, 10)
		credits.offset = camlimit.offset
		camlimit.limit_left = 0
		camlimit.limit_right = 1100
		owner.add_child(camlimit)
		Player.remove_child(camlimit)
		camlimit.position.y = Player.global_position.y
		camlimit.position.x = 620
		if facedirection.y < 0 and timer4.time_left == 0:
			timer4.start()
		elif not facedirection.y < 0:
			timer5.start()
func shoot():
	vine = load("res://Scenes/Prefabs/vineattack.tscn")
	b = vine.instantiate()
	if health > 2:
		b.playa = Player.global_position
		owner.add_child(b)
		b.isfalling = 0
		b.position.y = randf_range(200, 400)
	else:
		b.isfalling = 1
	b.position.x = randf_range(250, 870)
	
	


func _on_timer_timeout():
	shoot()
	shoot()
	shoot()
	timer.start()

func _on_timer_2_timeout():
	shoot2()

func shoot2():
	rainbullet = load("res://Scenes/Prefabs/RainBullet.tscn")
	var b = rainbullet.instantiate()
	b.playa = Player.position
	owner.add_child(b)
	b.speed = 3
	b.position = Vector2(randf_range(0, 1000), 200)
	b.scale = Vector2(2, 2)


func shoot3():
	if health > 2:
		flowerbullet = load("res://Scenes/Prefabs/flowerbullet.tscn")
		b = flowerbullet.instantiate()
		b.falling = 0
		b.playa = Player.position
		owner.add_child(b)
		b.transform = self.global_transform
	else:
		print("shot")
		flowerbullet = load("res://Scenes/Prefabs/flowerbullet2.tscn")
		b = flowerbullet.instantiate()
		b.falling = 1
		b.playa = facedirection
		self.add_child(b)

func _on_timer_3_timeout():
	shoot3()


func _on_painbox_area_entered(area):
	if area.is_in_group("slash"):
		if health == 2:
			var tween = create_tween()
			tween.EASE_IN
			tween.tween_property(self, "position", Vector2(544, 580), 1)
		if health == 1 and ending != 1:
			camlimit.zoom = Vector2(1, 1)
			AudioManager.over.play()
			Engine.time_scale = 0.25
			await get_tree().create_timer(0.35).timeout
			Engine.time_scale = 0.01
			await get_tree().create_timer(0.02).timeout
			Engine.time_scale = 1
			self.position.x = self.position.x - 400
			AudioManager.kbangry.play()
			splode.emitting = true
			ending = 1
		if health < 5 and health > 1:
			await get_tree().create_timer(0.1).timeout
			health = health - 1
		if health > 0 and health >= 5:
			health = health - 1
			AudioManager.kubjellehurt.play()
		var tween = create_tween()
		tween.tween_property(kbhealth, "value", health, 0.1)
		if health == 1 and ending == 1:
			var tween2 = create_tween()
			kbhealth.value = 20
			tween2.tween_property(kbhealth, "value", 0.1, 30)
		if ending == 1 and end2 == 0:
			end2 = 1
			startending()			
		Phealth.heal()
		print(health)
		modulate = Color(255, 255, 255, 1)
		await get_tree().create_timer(0.1).timeout
		modulate = Color(1, 1, 1, 1)


func _on_timer_4_timeout():
	shoot3()


func startending():
	swordsprite.visible = true
	await get_tree().create_timer(10).timeout
	credits.play("default")
	credits.visible = true
	credits.scale = Vector2(0.8, 0.8)
	credits.position.y = 800
	var tw = create_tween()
	print("mark hit")
	tw.tween_property(credits, "position", Vector2(-40, -200), 0.2)
	await get_tree().create_timer(1).timeout
	tw = create_tween()
	tw.tween_property(credits, "position", Vector2(-40, -300), 5)
	await get_tree().create_timer(5).timeout
	tw = create_tween()
	tw.tween_property(credits, "position", Vector2(-40, -900), 0.2)
	await get_tree().create_timer(3).timeout
	credits.position.y = 800
	credits.play("bygira")
	tw = create_tween()
	tw.tween_property(credits, "position", Vector2(-40, -200), 0.2)
	await get_tree().create_timer(1).timeout
	tw = create_tween()
	tw.tween_property(credits, "position", Vector2(-40, -300), 5)
	await get_tree().create_timer(5).timeout
	tw = create_tween()
	tw.tween_property(credits, "position", Vector2(-40, -900), 0.2)
	await get_tree().create_timer(8).timeout
	tw = create_tween()
	credits.play("pl")
	credits.position.y = 300
	tw.tween_property(credits, "position", Vector2(-40, -300), 0.8)
	AudioManager.kbangry.play()
	Engine.time_scale = 0.1
	await get_tree().create_timer(0.7).timeout
	AudioManager.finalk.volume_db = -80
	var spot = AudioEffectPitchShift.new()
	Engine.time_scale = 1
	AudioManager.whichmusic = 1
	SceneTransition.scene_num = 4
	SceneTransition.load_scene(4)
