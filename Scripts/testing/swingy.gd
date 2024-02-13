extends Node2D
@onready var player = %Player
@onready var base = $StaticBody2D
@onready var cam = %Camera2D
@onready var topchain = $StaticBody2D/PinJoint2D/Topchain
@onready var lantern = $StaticBody2D/PinJoint2D/Topchain/PinJoint2D/Bottomchain/PinJoint2D/Bottomchain2/Sprite2D2
@onready var lantern2 = $StaticBody2D/PinJoint2D/Topchain/PinJoint2D/Bottomchain/PinJoint2D/Bottomchain2

# Called when the node enters the scene tree for the first time.
func _ready():
	lantern2.gravity_scale = randf_range(1.5, 2.65)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.velocity.x != 0:lantern2.apply_force(Vector2(-player.velocity.x * 2, 0))
	if self.name == "swingy5":
		if Phealth.h >=1:
			lantern.play("Lit")
		else:
			lantern.play("Out")
	if self.name == "swingy4":
		if Phealth.h >=2:
			lantern.play("Lit")
		else:
			lantern.play("Out")
	if self.name == "swingy3":
		if Phealth.h >=3:
			lantern.play("Lit")
		else:
			lantern.play("Out")
	if self.name == "swingy2":
		if Phealth.h >=4:
			lantern.play("Lit")
		else:
			lantern.play("Out")
	if self.name == "swingy1":
		if Phealth.h >=5:
			lantern.play("Lit")
		else:
			lantern.play("Out")
