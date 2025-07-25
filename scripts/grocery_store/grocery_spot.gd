extends Node2D

@export var item: GroceryItem

var next_to_shelf: bool

func _ready() -> void:
	$E_Popup.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") && next_to_shelf:
		Globals.groceries.append(item)
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_class("CharacterBody2D"):
		next_to_shelf = true
		$E_Popup.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_class("CharacterBody2D"):
		next_to_shelf = false
		$E_Popup.visible = false
