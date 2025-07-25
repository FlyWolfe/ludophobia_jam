extends PanelContainer

const GAME = preload("res://scenes/apartment.tscn")
const GROCERY = preload("res://scenes/grocery_store.tscn")
const SIDE = preload("res://scenes/overworld.tscn")

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(GAME)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_temp_grocery_button_pressed() -> void:
	get_tree().change_scene_to_packed(GROCERY)


func _on_temp_side_button_pressed() -> void:
	get_tree().change_scene_to_packed(SIDE)
