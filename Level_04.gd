extends Node2D
@onready var kubhealth = $Kubjellebig
@onready var spawn_point = $Level/SpawnPoint
# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.whichmusic = 4
	Saveload.savegame(spawn_point.global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

