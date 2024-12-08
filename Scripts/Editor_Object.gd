extends Node2D

@onready var level = get_node("/root/Main/Level")
@onready var tilemap = get_node("/root/Main//Level/TileMap")

var can_place = true
var current_item
var tile_size = Vector2(16, 16)
var tile_size_x = 16
var tile_size_y = 16

var new_item
var character_info = {}
var pending_character_data = {}

func _ready():
	pass

func _process(_delta):
	var global_position = get_global_mouse_position()
	
	if current_item != null and can_place:
		if Input.is_action_pressed("mb_left"):
			# Instantiate the item if it hasn't been instantiated yet
			if not new_item:
				new_item = current_item.instantiate()
				level.add_child(new_item)
			
			# Snap item to grid and follow the mouse
			var grid_x = round(global_position.x / tile_size_x) * tile_size_x + tile_size_x / 2
			var grid_y = round(global_position.y / tile_size_y) * tile_size_y + tile_size_y / 2
			
			new_item.global_position = Vector2(grid_x, grid_y)
			
		elif Input.is_action_just_released("mb_left"):
			# Finalize placement
			if new_item:
				var scene = preload("res://Scenes/character_info.tscn").instantiate()
				var root = get_tree().root
				root.add_child(scene)
				
				# Snap item to grid (recalculate position to ensure proper placement)
				var grid_x = round(global_position.x / tile_size_x) * tile_size_x + tile_size_x / 2
				var grid_y = round(global_position.y / tile_size_y) * tile_size_y + tile_size_y / 2
				new_item.global_position = Vector2(grid_x, grid_y)
				
				var tile_position = getCorrds(new_item.global_position)
				
				character_info["position"] = tile_position
				
				scene.connect("character_info_confirmed", Callable(self, "_on_character_info_confirmed"))
				
				Global.pending_character_data[new_item] = tile_position
		
			# Reset current item
			new_item = null
			current_item = null
	
func getCorrds(world_position: Vector2) -> Vector2:
	return (world_position)
