extends Node

@export var save_file: Resource
# Called when the node enters the scene tree for the first time.
var save_pos = "user://score.save"
var save_scene = "user://scene.save"
var difficulty = "user://difficulty.save"
var saveloc = "user://save_game.tres"
var items : ItemList
@export var diffsetting : String
@onready var spawn = %SpawnPoint
var goto = Vector2(0,0)
var load = 0
func _ready():
	save_file = load("res://resources/save_resource.tres")
	save_file.skill = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func load_diff():
	var diff = FileAccess.open(difficulty, FileAccess.READ)
	if FileAccess.file_exists(difficulty):
		diffsetting = diff.get_var()
	else:
		savediff("easy")
		diffsetting = "easy"
func savediff(di: String):
	var diff = FileAccess.open(difficulty, FileAccess.WRITE)
	diff.store_var(di)
func savegame(abc: Vector2):
	var spawn = abc
	save_file.progress = Phealth.progress
	save_file.saved_scene = SceneTransition.scenern
	save_file.open_doors = Phealth.open_doors
	save_file.saved_position = abc
	save_file.arrayi = Phealth.invarray
	ResourceSaver.save(save_file, saveloc)
	print("saved position: ", save_file.saved_position, ",  (from: saveload.gd)")
	print("saved scene: ", save_file.saved_scene, ",  (from: saveload.gd)")
func loadgame():
	
	if FileAccess.file_exists(saveloc):
		load = 1
		print("file found")
		var diff = FileAccess.open(difficulty, FileAccess.READ)
		var savedpos = ResourceLoader.load(saveloc)
		save_file.saved_position = savedpos.saved_position
		save_file.saved_scene = savedpos.saved_scene
		save_file.progress = savedpos.progress
		save_file.arrayi = savedpos.arrayi
		save_file.open_doors = savedpos.open_doors
		Phealth.open_doors = save_file.open_doors
		Phealth.invarray = save_file.arrayi
		print("position retrieved: ",save_file.saved_position, ",  (from: saveload.gd)")
		SceneTransition.load_scene2(save_file.saved_scene)
		print("scene retrieved: ", save_file.saved_scene, ",  (from: saveload.gd)")
		var playercharacter = %Player
		await get_tree().create_timer(0.4).timeout
		goto = save_file.saved_position
		print(goto)
		print(SceneTransition.scene_num)

