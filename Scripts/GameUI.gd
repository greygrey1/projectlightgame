extends Control

@onready var score_texture = %Score/ScoreTexture
@onready var score_texture2 = %Score/ScoreTexture2
@onready var score_texture3 = %Score/ScoreTexture3
@onready var score_texture4 = %Score/ScoreTexture4
@onready var score_texture5 = %Score/ScoreTexture5
@onready var score_label = %Inventory/ScoreLabel
@onready var text = $AnimationPlayer
@onready var inv = $Inventory
@onready var invtext = %Inventory/InvText
@onready var Player = %Player
@onready var healthsprite = $Score/healthsprite
@onready var sbt = $SubTitle
var thetext : String = ""
var sbfd
var inventoryopen = 0
func _ready():
	inv.visible = false
	if sbt != null:
		sbt.modulate = Color(1, 1, 1, 0)
func _process(_delta):
	if sbt!=null:
		sbt.pivot_offset.x = sbt.size.x/2
	# Set the score label text to the score variable in game maanger script
	score_label.text = "x %d" % GameManager.score
	invtext.text = thetext
	healthcheck2()
	invcheck()
	if Input.is_action_just_pressed("5"):
		sub("asdhfohsfhashdfad")
	
func healthcheck2():
	pass
	

func healthcheck():
	if Phealth.h > 4:
		score_texture5.visible = true
	else:
		score_texture5.visible = false
	if Phealth.h > 3:
		score_texture4.visible = true
	else:
		score_texture4.visible = false
	if Phealth.h > 2:
		score_texture3.visible = true
	else:
		score_texture3.visible = false
	if Phealth.h > 1:
		score_texture2.visible = true
	else:
		score_texture2.visible = false
	if Phealth.h > 0:
		score_texture.visible = true
	else:
		score_texture.visible = false

func invcheck():
	if Input.is_action_just_pressed("Inventory"):
		if inventoryopen == 0:
			inv.open()
			inventoryopen = 1
			inv.visible = true
			Player.canmove = 0
		elif inventoryopen == 1:
			inv.close()
			inventoryopen = 0
			inv.visible = false
			Player.canmove = 1




func _on_checkpoint_area_entered(area):
	pass # Replace with function body.


func _on_area_2d_mouse_entered():
	thetext = "A crude sword from a long forgotten time. Deals one damage."


func _on_area_2d_mouse_exited():
	thetext = ""

func sub(a: String):
	sbt.text = "[center]%s[/center]" % a
	sbt.modulate = Color(1, 1, 1, 1)
	await get_tree().create_timer(0.05).timeout
	for i in 20:
		sbt.modulate = sbt.modulate - Color(0, 0, 0, 0.05)
		await get_tree().create_timer(0.1).timeout
	
	
