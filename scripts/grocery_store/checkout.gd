extends Node2D

const CONVEYOR = preload("res://scenes/grocery_store.tscn")

var at_checkout: bool

func _ready() -> void:
	$E_Popup.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") && at_checkout:
		get_tree().change_scene_to_packed(CONVEYOR)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_class("CharacterBody2D"):
		at_checkout = true
		$E_Popup.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_class("CharacterBody2D"):
		at_checkout = false
		$E_Popup.visible = false
