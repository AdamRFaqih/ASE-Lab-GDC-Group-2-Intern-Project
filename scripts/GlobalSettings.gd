extends Node

#update background music volume and convert from value (in range of 0 to 2) to dB
func update_music_volume(value):
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(1, db)

#update sound effects volume and convert from value (in range of 0 to 2) to dB
func update_sfx_volume(value):
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(2, db)
