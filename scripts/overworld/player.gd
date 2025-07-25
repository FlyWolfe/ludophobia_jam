extends CharacterBody2D
class_name Player

@export var down_sprite: Sprite2D
@export var up_sprite: Sprite2D

@export var pedometer: Label
@export var distance_per_step: float = 100

@export var movement_speed: float = 500.0

var last_pos: Vector2
var cumulative_distance: float = 0.0

func _ready() -> void:
	last_pos = position
	Globals.player = self

func _physics_process(delta: float) -> void:
	var vel: Vector2 = Vector2.ZERO
	var input_x = Input.get_axis("left", "right")
	var input_y = Input.get_axis("up", "down")
	vel.x = input_x
	vel.y = input_y
	
	velocity = vel.normalized() * movement_speed
	move_and_slide()
	
	if velocity.length() != 0:
		$AnimationPlayer.play("waddle")
	else:
		$AnimationPlayer.play("idle")
	
	if input_y < 0:
		up_sprite.visible = true
		down_sprite.visible = false
	elif input_y > 0:
		up_sprite.visible = false
		down_sprite.visible = true
	
	var delta_position = (position - last_pos).length()
	cumulative_distance += delta_position
	if cumulative_distance >= distance_per_step:
		cumulative_distance = 0.0
		pedometer.step()
	
	last_pos = position
