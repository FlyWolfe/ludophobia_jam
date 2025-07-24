extends PanelContainer
class_name Petogatchi

@export var texture_rect: TextureRect
@export var label: Label

@export var dialogues: Array[PetDialogue]

var current_dialogue: int

func _ready() -> void:
	Globals.petogatchi = self
	current_dialogue = 0
	self.visible = false

func _physics_process(delta: float) -> void:
	if current_dialogue >= dialogues.size():
		return
	var dialogue = dialogues[current_dialogue]
	if Globals.pedometer.steps >= dialogue.steps:
		label.text = dialogue.text
		texture_rect.texture = dialogue.image
		current_dialogue += 1
		open_pet()

func open_pet():
	self.visible = true

func close_pet():
	self.visible = false

func _on_feed_button_pressed() -> void:
	close_pet()
