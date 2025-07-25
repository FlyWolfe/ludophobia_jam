extends Node2D

const OVERWORLD = preload("res://scenes/overworld.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_class("CharacterBody2D"):
		get_tree().change_scene_to_packed(OVERWORLD)
