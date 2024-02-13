extends Node2D
var trampoline : PackedScene
@onready var player = %Player
var seedcount = 0
var seeds
@onready var tile_map = $Level/TileMap
@onready var doorslist = $Level/Doors
@onready var textbox = $UserInterface/GameUI/TextBox
@onready var kal = $UserInterface/GameUI/KaliaScene
@onready var kala = $UserInterface/GameUI/KaliaScene/AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	make_hoverbug(Vector2(15993, -2752), -2752, -2650)
	SceneTransition.scene_num = 4
	AudioManager.whichmusic = 6
	Saveload.load_diff()
	for i in Phealth.open_doors.size():
		find_child("Level").find_child("Doors").find_child(Phealth.open_doors[i]).open()
	print("seed loaded", ", ", "(from Level_05.gd)")
	trampoline = load("res://Scenes/Prefabs/seed.tscn")
	var seeds = trampoline.instantiate()
	self.add_child(seeds)
	seeds.global_position = Vector2(16870, 180)
	seeds.area_entered.connect(seeds._on_body_entered)
	make_trampoline(Vector2(13947, -550))
	if Saveload.diffsetting == "easy":
		trampoline = load("res://Scenes/Prefabs/trampo.tscn")
		var b = trampoline.instantiate()
		self.add_child(b)
		b.global_position = Vector2(19136, 118)
		b.scale = Vector2(1.607, 1.607)
		b.area_entered.connect(player._on_trampoline_area_entered)
	else:
		print("difficulty: ", Saveload.diffsetting)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.reset == 1 and not get_node("Seed"):
		await GameManager.reset == 0
		print("seed loaded", ", ", "(from Level_05.gd)")
		trampoline = load("res://Scenes/Prefabs/seed.tscn")
		var seeds = trampoline.instantiate()
		self.add_child(seeds)
		seeds.global_position = Vector2(16870, 180)
		seeds.area_entered.connect(seeds._on_body_entered)
	if Input.is_action_just_pressed("ui_accept") and not $VidTimer.is_stopped():
		$VidTimer.stop()
		$VidTimer.wait_time = 1
		$VidTimer.start()

func make_trampoline(trp: Vector2):
	trampoline = load("res://Scenes/Prefabs/trampo.tscn")
	var b = trampoline.instantiate()
	self.add_child(b)
	b.global_position = trp
	b.scale = Vector2(1.607, 1.607)
	b.area_entered.connect(player._on_trampoline_area_entered)
	
func make_hoverbug(trp: Vector2, tr2: int, tr3: int):
	trampoline = load("res://Scenes/Prefabs/enemies/hover_bug.tscn")
	var b = trampoline.instantiate()
	b.high = tr2
	b.low = tr3
	b.global_position = trp
	self.add_child(b)



func _on_area_2d_16_body_entered(body):
	if body.is_in_group("Player") and not Phealth.open_doors.has("HuntDoorLeft"):
		await get_tree().create_timer(1).timeout
		player.canmove = 0
		textbox.cutscene = 4
		await textbox.cutscene_over
		AudioManager.whichmusic = 8
		var hunta : PackedScene
		hunta = load("res://Scenes/Prefabs/hunter/hunter.tscn")
		var hunt = hunta.instantiate()
		hunt.GameUI = $UserInterface/GameUI
		hunt.hbar = $UserInterface/GameUI/HunterBar
		hunt.player = $Player
		hunt.global_position = Vector2(3777, 245)
		self.add_child(hunt)
		hunt.hunterisdead.connect(hunter_died)
		hunt.hunterisdead.connect(doorslist.get_child(0).open)
		hunt.hunterisdead.connect(doorslist.get_child(1).open)

func hunter_died():
	$UserInterface/GameUI/HunterBar.visible = false

func kalia_scene1():
	AudioManager.whichmusic = -1
	player.canmove = 0
	kal.visible = true
	AudioManager.whichmusic = 9
	await get_tree().create_timer(0.1).timeout
	var tween = create_tween()
	await tween.tween_property(kal, "chrspread", 0.015, 1).finished
	print(kal.chrspread)
	kala.play("Open")
	await kala.animation_finished
	kala.play("idle")
	player.canmove = 0
	textbox.cutscene = 5


func _on_text_box_start_explain():
	AudioManager.whichmusic = -1
	$UserInterface/GameUI/cutscenexpos.visible = true
	$UserInterface/GameUI/cutscenexpos.paused = false
	$UserInterface/GameUI/cutscenexpos.play()
	$VidTimer.start()
	await $VidTimer.timeout
	print("haugh")
	$UserInterface/GameUI/cutscenexpos.stop()
	$UserInterface/GameUI/cutscenexpos.visible = false
	$UserInterface/GameUI/cutscenexpos.paused = true
	textbox.cutscene = 6
	AudioManager.whichmusic = 9


func _on_text_box_end_kalia():
	kala.play_backwards("Open")
	await kala.animation_finished
	kala.play("default")
	var tween = create_tween()
	await tween.tween_property(kal, "chrspread", 0.0, 1).finished
	kal.visible = false
	AudioManager.musictrans("kaliatheme", 7)
