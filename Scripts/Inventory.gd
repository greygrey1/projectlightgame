extends Control
@onready var items = $ItemList
@onready var Sword = $Sword
var texturei
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func open():
	items.clear()
	for i in Phealth.invarray.size():
		items.add_item(Phealth.invarray[i], load("res://inventory/" + Phealth.invarray[i] + ".png"))
	
	
func close():
	pass
