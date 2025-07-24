extends Node2D

class GridSpace:
	var occupied: bool
	var placed_item_index: int

@export var starting_columns: int = 2
@export var conveyor_start: Vector2i = Vector2i(-9, -2)
@export var conveyor_end: Vector2i = Vector2i(8, 1)

@export var conveyor_map: TileMapLayer
@export var placing_map: TileMapLayer

@export var grocery_items: Array[GroceryItem]
@export var x_tile: Vector2i = Vector2i(7, 5)

@export var conveyor_move_rate: float = 2.0

var columns: int
var rows: int
var available_columns: int
var current_item: GroceryItem

enum Rot {
	Normal,
	Right,
	Down,
	Left
}
var tile_rotation: Rot

var timer: float


func _ready():
	columns = conveyor_end.x - conveyor_start.x
	rows = conveyor_end.y - conveyor_start.y
	available_columns = starting_columns
	current_item = grocery_items.pick_random()
	timer = conveyor_move_rate
	tile_rotation = Rot.Normal

func _process(delta: float) -> void:
	var place = Input.is_action_just_released("place")
	if !place:
		if Input.is_action_just_pressed("left"):
			rotate_tile_left()
		if Input.is_action_just_pressed("right"):
			rotate_tile_right()
	
	placing_map.clear()
	var mouse_tile_pos = placing_map.local_to_map(placing_map.to_local(get_global_mouse_position()))
	
	var tiles_to_place: Array[Vector4i] = []
	
	for row in range(current_item.tiles.size()):
		var map_pos = mouse_tile_pos
		var left_pos = get_tile_map_pos(map_pos, row, true)
		var right_pos = get_tile_map_pos(map_pos, row, false)
		
		if tile_on_conveyor(left_pos, current_item.tiles[row].tile_left):
			preview_tile(left_pos, current_item.tiles[row].tile_left)
		if tile_on_conveyor(right_pos, current_item.tiles[row].tile_right):
			preview_tile(right_pos, current_item.tiles[row].tile_right)
		
		if place:
			var left = current_item.tiles[row].tile_left
			var right = current_item.tiles[row].tile_right
			if left.x >= 0: # valid left tile
				tiles_to_place.append(Vector4i(left_pos.x, left_pos.y, left.x, left.y))
			if right.x >= 0: # valid right tile
				tiles_to_place.append(Vector4i(right_pos.x, right_pos.y, right.x, right.y))
		
	if place:
		if can_place(tiles_to_place):
			for tile in tiles_to_place:
				place(Vector2i(tile.x, tile.y), Vector2i(tile.z, tile.w))
			current_item = grocery_items.pick_random()
	
	timer -= delta
	if timer <= 0.0:
		timer = conveyor_move_rate
		move_conveyor()

func rotate_tile_left():
	match tile_rotation:
		Rot.Normal:
			tile_rotation = Rot.Left
		Rot.Right:
			tile_rotation = Rot.Normal
		Rot.Down:
			tile_rotation = Rot.Right
		Rot.Left:
			tile_rotation = Rot.Down

func rotate_tile_right():
	match tile_rotation:
		Rot.Normal:
			tile_rotation = Rot.Right
		Rot.Right:
			tile_rotation = Rot.Down
		Rot.Down:
			tile_rotation = Rot.Left
		Rot.Left:
			tile_rotation = Rot.Normal

func get_tile_map_pos(mouse_pos: Vector2i, row: int, is_left_tile: bool):
	var map_pos = mouse_pos
	match tile_rotation:
		Rot.Normal:
			map_pos.y += row
			if is_left_tile:
				return map_pos
			map_pos.x += 1
			return map_pos
		Rot.Right:
			map_pos.x -= row
			if is_left_tile:
				return map_pos
			map_pos.y += 1
		Rot.Down:
			map_pos.y -= row
			if is_left_tile:
				return map_pos
			map_pos.x -= 1
		Rot.Left:
			map_pos.x += row
			if is_left_tile:
				return map_pos
			map_pos.y -= 1
	return map_pos

func preview_tile(pos: Vector2i, tile: Vector2i):
	if tile.x < 0:
		return
	if conveyor_map.get_cell_tile_data(pos) != null:
		placing_map.set_cell(pos, 0, x_tile)
		return
	placing_map.set_cell(pos, 0, tile)
	
func can_place(tiles: Array[Vector4i]):
	for tile in tiles:
		var pos = Vector2i(tile.x, tile.y)
		var tile_coords = Vector2i(tile.z, tile.w)
		if !can_place_tile(pos, tile_coords):
			return false
	return true

func tile_on_conveyor(pos: Vector2i, tile_coords: Vector2i):
	if pos.x < conveyor_start.x || pos.x > conveyor_end.x || pos.y < conveyor_start.y || pos.y > conveyor_end.y:
			return false
	#if pos.x >= conveyor_start.x + available_columns:
	#	return false
	return true

func can_place_tile(pos: Vector2i, tile_coords: Vector2i):
	if pos.x < conveyor_start.x || pos.x > conveyor_end.x || pos.y < conveyor_start.y || pos.y > conveyor_end.y:
			return false
	if pos.x >= conveyor_start.x + available_columns:
		return false
	if tile_coords.x > 0 && conveyor_map.get_cell_tile_data(pos) != null:
		return false
	return true
	
func place(pos: Vector2i, tile_coords: Vector2i):
	conveyor_map.set_cell(pos, 0, tile_coords)

func move_conveyor():
	if available_columns > columns:
		return
	 
	available_columns += 1
	for i in range(conveyor_end.x, conveyor_start.x - 1, -1):
		for j in range(conveyor_end.y, conveyor_start.y - 1, -1):
			var tile_to_left = Vector2i(-1, -1)
			if (i > conveyor_start.x):
				tile_to_left = conveyor_map.get_cell_atlas_coords(Vector2i(i - 1, j))
			conveyor_map.set_cell(Vector2i(i, j), 0, tile_to_left)
