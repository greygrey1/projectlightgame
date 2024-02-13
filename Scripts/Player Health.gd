extends Node2D
@export var h : int
@export var knockback : int
@export var knb : Vector2
@export var timetogo : int
@export var final = 0
@export var vine : int
@export var off : int
@export var seed_count : int
@export var campos1 : Vector2
@export var campos2 : Vector2
@onready var invitems = $ItemList
@export var progress : int
@export var invarray : PackedStringArray
@onready var itemslist : Array
@export var open_doors: PackedStringArray
# Called when the node enters the scene tree for the first time.
func _ready():
	invarray.append("Sword")
	h = 5
	timetogo = 0
	seed_count = 0

func heal():
	if h < 5:
		h = h + 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("damage"):
		damage()
	if h < 1:
		seed_count = 0
		await get_tree().create_timer(0.05).timeout
		h = 5
		
func damage():
	Phealth.h = Phealth.h - 1
	AudioManager.dmgs.play()
