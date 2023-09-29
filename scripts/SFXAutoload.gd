extends Node

@onready var audio_players = $AudioPlayers
@onready var audio_stream_player_2d = $AudioPlayers/AudioStreamPlayer

const JUMP = preload("res://assets/sfx/8bit_Jump.mp3")
const BOUNCE = preload("res://assets/sfx/8bit_Bounce.mp3")
const GAME_OVER = preload("res://assets/sfx/8bit_Game_Over.mp3")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_sfx(sound):
	for audioStreamPlayer in audio_players.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break
