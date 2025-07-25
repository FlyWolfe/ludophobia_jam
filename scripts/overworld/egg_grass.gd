extends Node2D

@export var contains_egg: bool

var player_in_grass: bool

func _ready() -> void:
	$E_Popup.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") && player_in_grass:
		print("Egg? " + str(contains_egg))
		if contains_egg:
			Globals.eggs += 1
			contains_egg = false
			if Globals.eggs >= 3:
				var temp_dialogue = Dialogue.new()
				temp_dialogue.text = "YOU SAVD MEH UGGGGSSSSS, YAYYYYY, TY GLHF"
				Globals.dialogue_box.add_dialouge(temp_dialogue)
				Globals.dialogue_box.open_dialogue_box()

func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body.get_class())
	if body.is_class("CharacterBody2D"):
		player_in_grass = true
		$E_Popup.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_class("CharacterBody2D"):
		player_in_grass = false
		$E_Popup.visible = false
