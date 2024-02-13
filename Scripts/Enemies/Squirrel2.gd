extends CharacterBody2D
var posx : int
var posy : int
@onready var spritecheck = $Sprite2D
@onready var go : int = 0
var initial_position := Vector2.ZERO
func _on_detection_body_entered(body):
	if body.is_in_group("Player"):
		go = 1
func _ready():
	position.x = 0
	position.y = 0
	


func _process(delta):
	if GameManager.reset == 1:
		go = 0
		velocity.y = 0
		position.x = 0
		position.y = 0
		
		print(position.x)
		print(position.y)
		
	if go == 1:
		var velocity = Vector2()
		velocity.y = 20
		position.y = velocity.y + position.y
		if position.y > 2000:
			go = 0
