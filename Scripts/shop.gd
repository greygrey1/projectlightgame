extends Node2D
@export var shopitems : ItemList
var itemiterate = 0
var itemscene : PackedScene
var xpos
# Called when the node enters the scene tree for the first time.
func _ready():
	xpos = -500
	if Saveload.prog
	shopitems.add_item("item1")
	shopitems.add_item("item1")
	initiate_items()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func initiate_items():
	while itemiterate < shopitems.item_count: 
		var itemname =shopitems.get_item_text(itemiterate)
		if itemname == "item1":
			additem("res://Scenes/Items/item_1.tscn")
		itemiterate += 1
			
			
func additem(item: String):
	itemscene = load(item)
	var b = itemscene.instantiate()
	self.add_child(b)
	b.global_position = Vector2(xpos, -225)
	b.mouse_entered.connect(self.send(b.name))
	xpos += 50
	
func send(name: String):
	print("sent")
