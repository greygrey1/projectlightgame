extends CharacterBody2D
var canfall: int = 1
var player
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var walking = 1
var fallmultiplier: int = 0
var facing: int
var yup2
var atcount : int = 0
var bhel : int = 30
var dying : bool = false
signal hunterisdead
@onready var dbox = $Area2D/CollisionShape2D
@onready var area = $Area2D
@onready var sprite = $AnimatedSprite2D
var GameUI
var hbar
var parried = 0
var ran : int = -1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var lastatk :int = -1

func _ready():
	dbox.disabled = true
	await NOTIFICATION_PARENTED
	hbar.visible = true
	await get_tree().create_timer(0.1).timeout
	if Saveload.diffsetting == "easy":
		$AttackTimer.wait_time = 5
	elif Saveload.diffsetting == "standard":
		print("standards")
		$AttackTimer.wait_time = 1
	
	
func _process(delta):
	if Phealth.h == 0: 
		AudioManager.whichmusic = 7
		queue_free()
	if bhel ==0 and dying ==false:
		dying = true
		endfight()
	if GameManager.reset == 1:
		bhel = 30
	hbar.value = bhel
	yup2 = player.global_position.y - 200
	if player.global_position > self.global_position:
		sprite.flip_h = false
		facing = 1
	else:
		sprite.flip_h = true
		facing = -1
	if walking ==1 and bhel > 0:
		velocity.x = facing*50
		sprite.play("default")
		
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if velocity.x > 10 or velocity.x < -10 and canfall == 0:
			velocity.x-=5
		elif canfall == 0:
			velocity.x = 0
		if canfall == 1:
			velocity.y += gravity * delta + fallmultiplier
	else:
		fallmultiplier = 0
	# Handle Jump.
	if Input.is_action_just_pressed("1"):
		attack1()
	if Input.is_action_just_pressed("2"):
		attack2()
	if Input.is_action_just_pressed("3"):
		attack3()

	move_and_slide()

func attack1():
	walking = 0
	if true:
		dbox.disabled = false
		sprite.play("Attack")
		AudioManager.sound("hunterswing.wav")
		if position.x - player.position.x > 200 or position.x - player.position.x < -200:
			target(800, 0.2, Vector2(50, 0))
		else:target(500, 0.1, Vector2(50, 0))
		dbox.scale = Vector2(2, 2)
		Phealth.knb = Vector2(facing*2, -800)
		check_parry()
		await sprite.animation_finished
		if not self.position.y - player.position.y > 100:
			dbox.disabled = false
			AudioManager.sound("hunterswing2.wav")
			sprite.play("combo2")
			target(500, 0.2, Vector2(50, -10))
			dbox.scale = Vector2(2, 2)
			Phealth.knb = Vector2(facing*2, -5)
			check_parry()
			await sprite.animation_finished
			var tween = self.create_tween()
			canfall = 0
			AudioManager.sound("hunterswing.wav")
			sprite.play("combo3")
			dbox.position = Vector2(0, 0)
			dbox.disabled = false
			dbox.scale = Vector2(2.5, 2.5)
			var yup = player.global_position.y - 500
			await tween.tween_property(self, "global_position", Vector2(player.global_position.x+ player.velocity.x/4, yup).clamp(Vector2(3023, -300), Vector2(4582, 268)), 1).set_trans(Tween.TRANS_SINE).finished
			canfall = 1
			fallmultiplier = 300
			AudioManager.sound("hunterland.wav")
			sprite.play("land")
			await area.body_entered
			player.launch()
			dbox.disabled = true
			dbox.scale = Vector2(1, 1)
		else:
			var tween = self.create_tween()
			canfall = 0
			dbox.position = Vector2(0, 0)
			dbox.disabled = false
			dbox.scale = Vector2(3, 3)
			sprite.play("combo3")
			await tween.tween_property(self, "global_position", Vector2(player.global_position.x, yup2), 0.3).set_trans(Tween.TRANS_SINE).finished
			tween = self.create_tween()
			Phealth.knb = Vector2(0, -1000)
			tween.tween_property(self, "global_position", Vector2(player.global_position.x + player.velocity.x/4, player.global_position.y).clamp(Vector2(3023, 268), Vector2(4582, -300)), 0.2).set_trans(Tween.TRANS_SINE)
			canfall = 1
			fallmultiplier = 500
			sprite.play("land")
			await area.body_entered
			player.launch()
			dbox.scale = Vector2(1, 1)
			dbox.disabled = true

			
		

func target(speed: int, time: int, dpos: Vector2):
	if player.position.x > self.position.x:
		dbox.position = dpos
		dbox.disabled = false
		velocity.x = speed
		sprite.flip_h = false
	else:
		dbox.disabled = false
		dbox.position = Vector2(-dpos.x, dpos.y)
		sprite.flip_h = true
		velocity.x = -speed
	await get_tree().create_timer(0.3).timeout
	dbox.disabled = true
	dbox.scale = Vector2(1, 1)
	velocity.x = 0
	
func target2(speed: int, time: int):
	if player.position.x > self.position.x:
			velocity.x = speed
	else:
		velocity.x = -speed
	await get_tree().create_timer(time).timeout
	


func _on_attack_timer_timeout():
	$AttackInterval.start()


func _on_area_2d_area_entered(area):
	if area.is_in_group("Player")  and area.name == "Collision" and dbox.disabled == false:
		Phealth.knockback = 1
		if parried ==0:
			AudioManager.dmgs.play()
			Phealth.h -= 1
		else:
			parried = 0
			

func attack2():
	walking = 0
	sprite.play("fall")
	await get_tree().create_timer(0.5).timeout
	sprite.play("land")
	spear_summon(15)
	await get_tree().create_timer(0.5).timeout


func spear_summon(spe: int):
	var sp : PackedScene
	sp = load("res://Scenes/Prefabs/hunter/spear.tscn")
	var s = sp.instantiate()
	s.dir = self.global_position.direction_to(player.global_position)
	s.speed = spe
	s.global_position = self.global_position
	s.dir2 = player.global_position
	get_parent().add_child(s)
func attack3():
	var tween = self.create_tween()
	canfall = 0
	sprite.play("combo3")
	dbox.position = Vector2(0, 0)
	dbox.disabled = false
	dbox.scale = Vector2(2.5, 2.5)
	var yup = player.global_position.y - 500
	await tween.tween_property(self, "global_position", Vector2(player.global_position.x+ player.velocity.x/4, yup).clamp(Vector2(3023, -300), Vector2(4582, 268)), 1).set_trans(Tween.TRANS_SINE).finished
	canfall = 1
	fallmultiplier = 400
	sprite.play("land")
	await area.body_entered
	player.launch()
	await get_tree().create_timer(0.2).timeout
	dbox.disabled = true
	dbox.scale = Vector2(1, 1)
	await get_tree().create_timer(0.1).timeout
	if self.position.y - player.position.y > 100:
		spear_summon(30)
	else:print(self.position.y - player.position.y)

func _on_attack_interval_timeout():
	sprite.stop()
	if atcount < 3:
		while ran == lastatk:
			atcount = atcount+1
			if position.x - player.position.x > 400 or position.x - player.position.x < -400:
				ran = randi_range(0, 3)
				print("all viable")
			elif position.x - player.position.x > 200 or position.x - player.position.x < -200:
				if bhel <=15:
					ran = randi_range(0, 2)
				else: 
					ran = randi_range(1, 2)
			else: 
				ran = 1
				print("too close")
				break
		lastatk = ran
		print("attack number: ", ran)
		if ran ==0:
			await attackthrow()
			GameUI.sub("throw_attack_voice_line.res")
		if ran ==1:
			var ran2 = randi_range(1, 2)
			if ran2 ==2:
				AudioManager.playsound("youaremyprey.mp3")
				GameUI.sub("You are my prey.")
			if ran2 ==1:
				AudioManager.playsound("youwilldie.mp3")
				GameUI.sub("You WILL DIE")
			await get_tree().create_timer(0.5).timeout
			await attack1()
		elif ran ==2:
			AudioManager.playsound("runningaway.mp3")
			GameUI.sub("Running away?")
			await attack2()
		elif ran ==3:
			AudioManager.playsound("foolish.mp3")
			GameUI.sub("FOOLISH")
			await get_tree().create_timer(0.3).timeout
			await attack3()
		walking = 1
		$AttackInterval.start()
	else:
		atcount = 0
		$AttackTimer.start()
	


func _on_area_2d_2_area_entered(area):
	if area.is_in_group("slash"):
		damage()
	

func check_parry():
	$Parryable.start()



func _on_area_2d_body_entered(body):
	if body.is_in_group("seed") and $Parryable.time_left > 0:
		if body.canparry == 1:
			body.parry()
			parried = 1
			Phealth.knockback = 1
			AudioManager.parry()
			print("parried")
			Engine.time_scale = 0.1
			await get_tree().create_timer(0.05).timeout
			player.shake()
			Engine.time_scale = 1
			velocity.x = -500*facing
			damage()
			await get_tree().create_timer(0.3).timeout
			parried = 0
func endfight():
	Phealth.h = 5
	$AttackTimer.paused = true
	$AttackInterval.paused = true
	walking = 0
	velocity.x = 0
	sprite.stop()
	AudioManager.whichmusic = -1
	AudioManager.playsound("hunterlose.mp3")
	var shakemount = 1
	canfall = 0
	for i in 10:
		if i == 5:
			GameUI.sub("You may have beaten me this time,")
		if i == 7:
			GameUI.sub("But the hunt")
		if i == 9:
			GameUI.sub("WILL")
		for b in 6:
			position.y -=1
			await get_tree().create_timer(0.1).timeout
			player.camshake(shakemount)
		shakemount +=1
	GameUI.sub("CONTINUE")
	await get_tree().create_timer(1).timeout
	player.camshake(20)
	emit_signal("hunterisdead")
	Phealth.open_doors.append("HuntDoorLeft")
	Phealth.open_doors.append("HuntDoorRight")
	var sh = load("res://Scenes/One_time_use/shardoflight.tscn")
	var shrd = sh.instantiate()
	get_parent().add_child(shrd)
	shrd.global_position = self.global_position
	shrd.collectedshard.connect(get_parent().kalia_scene1)
	self.queue_free()

func damage():
	bhel -= 1
	if bhel == 15:
		if Saveload.diffsetting == "easy":
			$AttackTimer.wait_time = 3
		elif Saveload.diffsetting == "standard":
			print("standards")
			$AttackTimer.wait_time = 0.7
			$AttackInterval.wait_time = 0.7

func attackthrow():
	print("throwing")
	var p : PackedScene = load("res://Scenes/Prefabs/enemies/splodeskull.tscn")
	var b = p.instantiate()
	b.player = player
	get_parent().add_child(b)
	b.scale = Vector2(2, 2)
	b.global_position = self.global_position
	print(b.global_position)
	await get_tree().create_timer(3).timeout
	
