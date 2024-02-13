class_name SaveGame
extends Resource

const SAVE_GAME_PATH := "res://savegame.res"
@export var global_position := Vector2.ZERO


func load_save():
	if ResourceLoader.exists(SAVE_GAME_PATH):
		return load(SAVE_GAME_PATH)
	return null
	
