extends Node2D
var touchingplayer : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("testkey"):
		if touchingplayer == true:
			if %Player.canmove == 0:
				%Player.canmove = 1
				%ShopV2.visible = false
				print("haugh")
				%ShopV2.close()
			elif %Player.canmove == 1:
				%Player.canmove = 0
				%ShopV2.visible = true
				%ShopV2.startup()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		touchingplayer = true


func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		touchingplayer = false
