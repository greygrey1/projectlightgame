extends CanvasLayer
@onready var Player = %Player
var menuopen = 0
var page = 0
@onready var page1 = $page1
@onready var page2 = $page2
@onready var button = $page1/Button
@onready var quit = $page1/quit
@onready var back = $page2/Back
@onready var check_button = $page2/CheckButton

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pausecheck()
	pagecheck()

func pausecheck():
	if Input.is_action_just_pressed("pause"):
		if menuopen == 0:
			page = 1
			menuopen = 1
			self.visible = true
			Player.canmove = 0
		elif menuopen == 1:
			page = 1
			menuopen = 0
			self.visible = false
			Player.canmove = 1

func pagecheck():
	if menuopen ==1:
		if page == 1:
			page1.visible = true
			button.disabled = false
			quit.disabled = false
		else:
			page1.visible = false
			button.disabled = true
			quit.disabled = true
		if page == 2:
			page2.visible = true
		else:
			page2.visible = false


func _on_button_pressed():
	page = 2
	back.disabled = false
	check_button.disabled = false
	print("setting opened,  ", "(from pausemenu.gd)")


func _on_quit_pressed():
	get_tree().quit()


func _on_back_pressed():
	page = 1
	check_button.disabled = true
	back.disabled = true


func _on_check_button_pressed():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		check_button.set_pressed_no_signal(false)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		check_button.set_pressed_no_signal(true)
