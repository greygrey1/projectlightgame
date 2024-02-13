extends Area2D
@onready var cam = %Camera2D
@onready var shape = $CollisionShape2D
@onready var timer = %SceneSwitchTimer
@export var pos1 : Vector2
@export var pos2 : Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_entered(area):
	if area.is_in_group("Player"):
		adjust()
func adjust():
	if not Phealth.campos1 == Phealth.campos2:
		timer.start()
		Phealth.campos2 = Phealth.campos1
	if position == Vector2(19300, 1075):
		cam.limit_left = 18482
		cam.limit_right = 19390
		cam.limit_bottom = 1755
		cam.limit_top = -1138
		Phealth.campos1 = position
		#First room
	if position == Vector2(18562, -685):
		cam.limit_left = 18482
		cam.limit_right = 19390
		cam.limit_bottom = 1755
		cam.limit_top = -1138
		Phealth.campos1 = position
		#Second room I think
	if position == Vector2(19362, 1073):
		cam.limit_left = 19330
		cam.limit_right = 22385
		cam.limit_bottom = 1755
		cam.limit_top = -1138
		Phealth.campos1 = position
		#IDK
	if position == Vector2(18480, -686):
		cam.limit_left = 17389
		cam.limit_right = 18540
		cam.limit_bottom = -388
		cam.limit_top = -1138
		Phealth.campos1 = position
		#First stag puzzle
	if position == Vector2(16755, -796):
		cam.limit_left = 16055
		cam.limit_right = 17350
		cam.limit_bottom = -388
		cam.limit_top = -1138
		Phealth.campos1 = position
		#First Save room
	if position == Vector2(16914, 14):
		cam.limit_left = 15138
		cam.limit_right = 17711
		cam.limit_bottom = 449
		cam.limit_top = -190
		Phealth.campos1 = position
		#Room below the first stag puzzle
	if position == Vector2(18103, 26):
		cam.limit_left = 17711
		cam.limit_right = 18750
		cam.limit_bottom = 449
		cam.limit_top = -402
		Phealth.campos1 = position
		#First loot room with a wolf
	if position == Vector2(14765, 28):
		cam.limit_left = 13324
		cam.limit_right = 15338
		cam.limit_bottom = 449
		cam.limit_top = -595
		Phealth.campos1 = position
		#Second save room
	if position == Vector2(14750, -824):
		cam.limit_left = 13324
		cam.limit_right = 15338
		cam.limit_bottom = -452
		cam.limit_top = -1600
		Phealth.campos1 = position
		AudioManager.whichmusic = 7
		#I think this is the room with the shopkeeper cutscene
	if position == Vector2(12615, -1635):
		cam.limit_left = 11854
		cam.limit_right = 13528
		cam.limit_bottom = -1325
		cam.limit_top = -2072
		Phealth.campos1 = position
		AudioManager.whichmusic = 7
		#Secret room thing
	if position == Vector2(15536, -798):
		cam.limit_left = 15045
		cam.limit_right = 16061
		cam.limit_bottom = -488
		cam.limit_top = -1122
		Phealth.campos1 = position
	if position == Vector2(13015, -794):
		cam.limit_left = 12298
		cam.limit_right = 13475
		cam.limit_bottom = -452
		cam.limit_top = -1122
		Phealth.campos1 = position
		#Shop room
	if position == Vector2(13884, -1635):
		cam.limit_left = 13494
		cam.limit_right = 14413
		cam.limit_bottom = -1172
		cam.limit_top = -2581
		Phealth.campos1 = position
		#Up from wall jump get
	if position == Vector2(14547, -2507):
		cam.limit_left = 14100
		cam.limit_right = 16412
		cam.limit_bottom = -2256
		cam.limit_top = -3000
		Phealth.campos1 = position
		#to the right now y'all
	if position == Vector2(14548, -2507):
		cam.limit_left = 0
		cam.limit_right = 30000
		cam.limit_bottom = 1000
		cam.limit_top = -5000
		Phealth.campos1 = position
	if position == Vector2(12500, -1700):
		#Chromatic Abboration Section
		cam.limit_left = 0
		cam.limit_right = 30000
		cam.limit_bottom = 1000
		cam.limit_top = -5000
		Phealth.campos1 = position
		AudioManager.whichmusic = -1
	if position == Vector2(3864, 30):
		#hunter room
		cam.limit_left = 2971
		cam.limit_right = 4648
		cam.limit_bottom = 401
		cam.limit_top = -450
		cam.zoom = Vector2(1.1, 1.1)
		Phealth.campos1 = position
	if position == Vector2(14587, -4015):
		cam.limit_left = 7673
		cam.limit_right = 10151
		cam.limit_bottom = -2852
		cam.limit_top = -3825
		Phealth.campos1 = position
	if position == Vector2(2500, 30):
		cam.limit_left = 2000
		cam.limit_right = 3500
		cam.limit_bottom = 401
		cam.limit_top = -450
		cam.zoom = Vector2(1.1, 1.1)
		Phealth.campos1 = position
		AudioManager.whichmusic = 7

			
		#TODO make camera transitions
		#too lazy to keep making camera transitions
