extends PanelContainer
class_name Petogatchi

@export var texture_rect: TextureRect
@export var label: Label

func _ready() -> void:
	Globals.petogatchi = self

func open_pet():
	pass

func close_pet():
	pass

func _on_feed_button_pressed() -> void:
	pass # Replace with function body.
