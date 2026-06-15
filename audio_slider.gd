extends HSlider

@export var audio_bus_name: String = "Master"

var audio_bus_id: int

func _ready() -> void:
	if audio_bus_name == "":
		audio_bus_name = "Master"
	audio_bus_id = AudioServer.get_bus_index(audio_bus_name)
	if audio_bus_id == -1:
		audio_bus_id = AudioServer.get_bus_index("Master")
	
	if audio_bus_id != -1:
		value = db_to_linear(AudioServer.get_bus_volume_db(audio_bus_id))

func _on_value_changed(value: float) -> void:
	if audio_bus_id != -1:
		AudioServer.set_bus_volume_db(audio_bus_id, linear_to_db(value))

