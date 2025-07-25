extends CharacterBody2D
class_name PlayerSide

@export var pedometer: Label
@export var distance_per_step: float = 100

@export var visuals: Node2D
@export var animator: AnimationPlayer

@export var movement_speed: float = 500.0

var last_pos: Vector2
var cumulative_distance: float = 0.0

func _ready() -> void:
	last_pos = position
	Globals.player_side = self

func _physics_process(delta: float) -> void:
	var vel: Vector2 = Vector2.ZERO
	var x_input := Input.get_axis("left", "right")
	var y_input := Input.get_axis("up", "down")
	vel.x = x_input
	vel.y = y_input
	
	velocity = vel.normalized() * movement_speed
	move_and_slide()
	
	if x_input != 0 || y_input != 0:
		animator.play("walk_left")
	else:
		animator.play("idle")
	
	if x_input != 0:
		visuals.scale.x = visuals.scale.y * -x_input
	
	var delta_position = (position - last_pos).length()
	cumulative_distance += delta_position
	if cumulative_distance >= distance_per_step:
		cumulative_distance = 0.0
		#pedometer.step()
	
	last_pos = position
