extends PanelContainer
class_name DialogueBox

@export var label: Label

@export var dialogue_queue: Array[Dialogue]

func _ready() -> void:
	Globals.dialogue_box = self
	self.visible = false

func _process(delta: float) -> void:
	if !self.visible:
		return
	
	if Input.is_action_just_pressed("interact"):
		next_dialogue()

func open_dialogue_box():
	if dialogue_queue.size() == 0:
		self.visible = false
		return
	self.visible = true
	label.text = dialogue_queue[0].text
	dialogue_queue.remove_at(0)

func add_dialouge(dialogue: Dialogue):
	dialogue_queue.append(dialogue)

func next_dialogue():
	if dialogue_queue.size() == 0:
		self.visible = false
		return
	label.text = dialogue_queue[0].text
	dialogue_queue.remove_at(0)
