extends Node2D

func _on_crack_body_entered(body: Node2D) -> void:
	if body.is_class("CharacterBody2D") && !$AudioStreamPlayer2D.playing:
		$AudioStreamPlayer2D.play(0.43)
