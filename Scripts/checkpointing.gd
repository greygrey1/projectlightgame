extends Area2D
@onready var anim = $AnimatedSprite2D
@onready var spawn_point = %SpawnPoint
@onready var anim2 = %Checkaim
# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("put_out")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	if area.is_in_group("Player"):
		anim.play("burning")
		spawn_point.global_position.x = self.global_position.x
		spawn_point.global_position.y = self.global_position.y
		
		Saveload.savegame(spawn_point.global_position)
		AudioManager.firewhoosh.play()
		anim2.play("Gamesaved")
