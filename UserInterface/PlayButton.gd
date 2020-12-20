tool 
extends Button

export(String, FILE) var next_screen_path: = ""

func _on_button_up():
	get_tree().change_scene(next_screen_path)
	PlayerData.score = 0
	get_tree().paused = false


func _get_configuration_warning() -> String:
	return "next_scene_path must be set for the button to work" if next_screen_path == "" else ""
