# This script is an autoload, that can be accessed from any other script!

extends Node
var whichmusic = 1
@onready var jump_sfx = $JumpSfx
@onready var coin_pickup_sfx = $CoinPickup
@onready var death_sfx = $DeathSfx
@onready var respawn_sfx = $RespawnSfx
@onready var level_complete_sfx = $LevelCompleteSfx
@onready var dash_sfx = $dash
@onready var music = $music
@onready var scene = 0
@onready var firewhoosh = $whoosh
@onready var seeboss = $BossSee
@onready var stagspeak = $stagspeak
@onready var fire = $crackle
@onready var bossmusic = $bossmusic
@onready var dmgs = $DamageSound
@onready var Bgmusic = $BGmusic
@onready var bossmusic2 = $bossmusic2
@onready var vineshoot = $VineShoot
@onready var finalk = $finalk
@onready var heart2 = $heart2
@onready var heart3 = $heart3
@onready var kubjellehurt = $kubjellehurt
@onready var trampoline = $trampoline
@onready var over = $thisisntover
@onready var kbangry = $kubjellesplode
@onready var huntertheme = $huntertheme
func _process(delta):
	if scene < 1:
		if !fire.is_playing():
			fire.play()
	elif fire.is_playing():
			fire.stop()
	if scene > 0 and whichmusic == 1:
		if !Bgmusic.playing:
			Bgmusic.play()
	elif Bgmusic.playing:
			Bgmusic.stop()
	if whichmusic == 2:
		if !seeboss.playing:
			seeboss.play()
	elif seeboss.playing:
			seeboss.stop()
	if whichmusic == 3:
		if !bossmusic.playing:
			bossmusic.play()
	elif bossmusic.playing:
			bossmusic.stop()
	if whichmusic == 4:
		if !bossmusic2.playing:
			bossmusic2.play()
	elif bossmusic2.playing:
			bossmusic2.stop()
	if whichmusic == 5:
		if !finalk.playing:
			finalk.play()
	elif finalk.playing:
		finalk.stop()
	if whichmusic == 6:
		if !heart2.playing:
			heart2.play()
	elif heart2.playing:
		heart2.stop()
	if whichmusic == 7:
		if !heart3.playing:
			heart3.play()
	elif heart3.playing:
		heart3.stop()
	if whichmusic == 8:
		if !$huntertheme.playing:
			$huntertheme.play()
	elif $huntertheme.playing:
		$huntertheme.stop()
	if whichmusic == 9:
		if !$kaliatheme.playing:
			$kaliatheme.play()
	elif $kaliatheme.playing:
		$kaliatheme.stop()

func parry():
	$AudioStreamPlayer2.stream = load("res://Assets/Sound/FX/parry1.wav")
	$AudioStreamPlayer2.play()
	await $AudioStreamPlayer2.finished
	$AudioStreamPlayer2.stream = load("res://Assets/Sound/FX/parry2.wav")
	$AudioStreamPlayer2.play()

func playsound(name: String):
	$AudioStreamPlayer.stream = load("res://Assets/Sound/FX/" + name)
	$AudioStreamPlayer.play()

func sound(name: String):
	var b : PackedScene = load("res://audio_play.tscn")
	var a = b.instantiate()
	a.stream = load("res://Assets/Sound/FX/" + name)
	self.add_child(a)
	a.play()
	await a.finished
	a.queue_free()
	
func musictrans(name: String, next: int):
	var tween = create_tween()
	await tween.tween_property(find_child(name), "volume_db", -30, 4).finished
	whichmusic = next
	$TransTimer.start()
	await $TransTimer.timeout
	find_child(name).volume_db = 0
