@tool
extends GridContainer

var is_editor_hint = true

func _ready():
	is_editor_hint = Engine.is_editor_hint()
	#if is_editor_hint:
	#	_update()


#func _process(_delta):
#	queue_redraw()
	
func _draw() -> void:
	if is_editor_hint:
		for position_node: Control in get_tree().get_nodes_in_group("position_nodes"):
			draw_rect(Rect2(position_node.get_transform().get_origin(), position_node.size), Color(1.0, 0.85, 0.65, 1.0), false, 2.0)
