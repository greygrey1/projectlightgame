extends Node
var numb = 0
var mytext : String = ""
var mytext2 : String = ""
var textnum = 0
var List
var listime
var cutscene : int = 0
var speaker
signal start_explain
signal cutscene_over
@onready var Player = %Player
@onready var end = $root/Cutscene
@onready var box = $Textbox
@onready var textint = $TextInterval
var maxtext 
var listime2
signal end_kalia
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if cutscene > 0:
		self.visible = true
	else:
		self.visible = false
	if speaker == "stag":
		box.modulate = Color(1, 1, 1, 1)
		$Sprite2D.visible = true
		$Sprite2D2.visible = false
	elif speaker == "kalia":
		box.modulate = Color(1, 1, 0.65, 1)
		$Sprite2D.visible = false
		$Sprite2D2.visible = true
	else:
		box.modulate = Color(1, 1, 1, 1)
		$Sprite2D.visible = false
		$Sprite2D2.visible = true
	checktyoe()
func checktyoe():
	if cutscene == 1:
		speaker = "stag"
		listime = [0.5, 0.05, 0.05, 0.05, 0.05, 0.05]
		maxtext = 6
		List = ["...", "I'll admit, when she said you'd be here, I was skeptical","I should have known better than to question her judgement.", "Fortunately for you, I am merciful", "I will give you this chance to turn back.", "If you do not, you will die."]
		if textnum > 5:
			cutscene = 0
			Player.canmove = 1
			AudioManager.whichmusic = 1
		else:
			mytext = List[textnum]
			listime2 = listime[textnum]
			textint.wait_time = listime2
			if textnum == 0 and numb == 0 and textint.is_stopped():
				textint.start()
		if Input.is_action_just_pressed("testkey"):
			numb = 0
			textnum = textnum + 1
			textint.start()
			print("tested")
	if cutscene == 2:
		speaker = "stag"
		listime = [0.05, 0.05, 0.05]
		maxtext = 3
		List = ["This decision is unfortunate.", "None have survived kubjelle.", "You will not be the first."]
		if textnum > 2:
			cutscene = 0
			Player.canmove = 1
			AudioManager.whichmusic = 3
		else:
			mytext = List[textnum]
			listime2 = listime[textnum]
			textint.wait_time = listime2
			if textnum == 0 and numb == 0 and textint.is_stopped():
				textint.start()
		if Input.is_action_just_pressed("testkey"):
			numb = 0
			textnum = textnum + 1
			textint.start()
			print("tested")
	if cutscene == 3:
		speaker = "stag"
		listime = [0.05, 0.05, 0.05, 0.05]
		maxtext = 4
		List = ["You have grown rusty, kubjelle.", "You are in luck, however,", "as malifa has generously decided to gift you with shadow.", "Do not waste it."]
		if textnum > 3:
			cutscene = 0
			Player.canmove = 1
			SceneTransition.scene_num = 3
			SceneTransition.load_scene(3)
			await get_tree().create_timer(0.3)
			print(SceneTransition.scene_num)
			SceneTransition.scene_num = 3
			SceneTransition.load_scene(3)
		else:
			mytext = List[textnum]
			listime2 = listime[textnum]
			textint.wait_time = listime2
			if textnum == 0 and numb == 0 and textint.is_stopped():
				textint.start()
		if Input.is_action_just_pressed("testkey"):
			numb = 0
			textnum = textnum + 1
			textint.start()
			print("tested")
	if cutscene == 4:
		speaker = "unknown"
		listime = [0.3]
		maxtext = 1
		List = ["I SEE YOU"]
		if textnum > 0:
			emit_signal("cutscene_over")
			cutscene = 0
			Player.canmove = 1
		else:
			mytext = List[textnum]
			listime2 = listime[textnum]
			textint.wait_time = listime2
			if textnum == 0 and numb == 0 and textint.is_stopped():
				textint.start()
		if Input.is_action_just_pressed("testkey"):
			numb = 0
			textnum = textnum + 1
			textint.start()
			print("tested")
	if cutscene == 5:
		speaker = "kalia"
		listime = [0.3, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05]
		List = ["HELLO, YOUNG ONE.", "I SEE YOU HAVE DEFEATED THE HUNTER.", "HE WILL BE BACK...", "BUT NO MATTER. WE WILL REACH THAT POINT EVENTUALLY.", "I SEEK TO GUIDE YOU ON YOUR JOURNEY.", "IT APPEARS THAT YOU DO NOT KNOW WHY YOU ARE HERE...", "HOW INTERESTING.", "ALLOW ME TO SHOW YOU..."]
		maxtext = List.size()
		if textnum > 7:
			emit_signal("start_explain")
			cutscene = 0
			textnum = 0
		else:
			mytext = List[textnum]
			listime2 = listime[textnum]
			textint.wait_time = listime2
			if textnum == 0 and numb == 0 and textint.is_stopped():
				textint.start()
		if Input.is_action_just_pressed("testkey"):
			numb = 0
			textnum = textnum + 1
			textint.start()
			print("tested")
	if cutscene == 6:
		speaker = "kalia"
		listime = [0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05]
		List = ["DO YOU SEE NOW, THE ATROCITIES THAT HAVE OCCURED?", "I AM CERTAIN THAT THIS IS THE REASON YOU WERE BROUGHT TO THIS WORLD", "I WILL ASSIST YOU WHERE I CAN, BUT HAVE LOST MUCH OF MY POWER I HAD IN ANCIENT TIMES.", "IF WE CAN GATHER MORE SHARDS LIKE THE ONE YOU JUST PICKED UP, I MAY BE ABLE TO RECLAIM MY FORMER GLORY.", "I SUSPECT THE HUNTER HAS MORE...", "FOR NOW, YOU CAN CALL UPON MY POWER USING \"S\".", "GOOD LUCK."]
		maxtext = List.size()
		if textnum > List.size() - 1:
			cutscene = 0
			Player.canmove = 1
			emit_signal("end_kalia")
		else:
			mytext = List[textnum]
			listime2 = listime[textnum]
			textint.wait_time = listime2
			if textnum == 0 and numb == 0 and textint.is_stopped():
				textint.start()
		if Input.is_action_just_pressed("testkey"):
			numb = 0
			textnum = textnum + 1
			textint.start()
			print("tested")
		

func type():
	if textnum < maxtext:
		if List[textnum].length() > numb - 1:
			box.text = mytext.substr(0, numb)
			AudioManager.stagspeak.play()
			await box.text == mytext.substr(0, numb)
			numb = numb + 1
			print(mytext.substr(0, numb))
	




func _on_text_interval_timeout():
	type()
	textint.start()
