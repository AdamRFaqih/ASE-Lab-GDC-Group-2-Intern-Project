extends Node

var current_score: int

#update background music volume and convert from value (in range of 0 to 2) to dB
func set_music_volume(value):
	print(value)
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(1, db)

#update sound effects volume and convert from value (in range of 0 to 2) to dB
func set_sfx_volume(value):
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(2, db)

func set_fullscreen(button_pressed):
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func set_input(input_id, current_input):
	match input_id:
		1: 
			InputMap.action_erase_events("left")
			InputMap.action_add_event("left", current_input)
		2: 
			InputMap.action_erase_events("right")
			InputMap.action_add_event("right", current_input)
		3: 
			InputMap.action_erase_events("jump")
			InputMap.action_add_event("jump", current_input)
		4: 
			InputMap.action_erase_events("pause")
			InputMap.action_add_event("pause", current_input)

func get_input(input_id):
	match input_id:
		1: return OS.get_keycode_string(InputMap.action_get_events("left")[0].keycode).to_upper()
		2: return OS.get_keycode_string(InputMap.action_get_events("right")[0].keycode).to_upper()
		3: return OS.get_keycode_string(InputMap.action_get_events("jump")[0].keycode).to_upper()
		4: return OS.get_keycode_string(InputMap.action_get_events("pause")[0].keycode).to_upper()

func store_score(score):
	current_score = score

func get_score():
	print(current_score)
	return current_score
