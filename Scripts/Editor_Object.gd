extends Node2D

@onready var level = get_node("/root/Main/Level")
var can_place = true
var current_item
var tile_size_x = 16
var tile_size_y = 16

func _ready():
	pass

func _process(_delta):
	global_position = get_global_mouse_position()
	
	if current_item != null and can_place == true and Input.is_action_pressed("mb_left"):
		var new_item = current_item.instantiate()
		
	elif current_item != null and can_place == true and Input.is_action_just_released("mb_left"):
		var new_item = current_item.instantiate()
		
		# Calculate nearest grid center position
		var grid_x = round(get_global_mouse_position().x / tile_size_x) * tile_size_x + tile_size_x / 2
		var grid_y = round(get_global_mouse_position().y / tile_size_y) * tile_size_y + tile_size_y / 2
		
		new_item.global_position = Vector2(grid_x, grid_y)
		
		level.add_child(new_item)
		current_item = null
		
		# Add character info popup when released
		var scene = preload("res://Scenes/character_info.tscn").instantiate()
		var root = get_tree().root
		root.add_child(scene)
