extends CharacterBody2D

@export var pedometer: Label
@export var distance_per_step: float = 100

@export var movement_speed: float = 500.0

var last_pos: Vector2
var cumulative_distance: float = 0.0

func _ready() -> void:
	last_pos = position

func _physics_process(delta: float) -> void:
	var vel: Vector2 = Vector2.ZERO
	vel.x = Input.get_axis("left", "right")
	vel.y = Input.get_axis("up", "down")
	
	velocity = vel.normalized() * movement_speed
	move_and_slide()
	
	var delta_position = (position - last_pos).length()
	cumulative_distance += delta_position
	if cumulative_distance >= distance_per_step:
		cumulative_distance = 0.0
		pedometer.step()
	
	last_pos = position
