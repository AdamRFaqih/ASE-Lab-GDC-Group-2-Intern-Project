extends Node

func update_music_vol(value_percent):
	var value_db = 10*log(value_percent/100)
	AudioServer.set_bus_volume_db(1, value_db)

func update_sfx_vol(value_percent):
	var value_db = 10*log(value_percent/100)
	AudioServer.set_bus_volume_db(2, value_db)
