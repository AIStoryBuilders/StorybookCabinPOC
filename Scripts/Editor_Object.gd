extends Node2D
@onready var level = get_node("/root/Main/Level")

var can_place = true
var current_item
var tile_size_x = 16 #change this so it is not hard coded when tilemap is inplemented
var tile_size_y = 16

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global_position = get_global_mouse_position()
	
	#snapping
	#global_position.x = ((round(global_position.x / tile_size_x)) * tile_size_x)
	#global_position.y = ((round(global_position.y / tile_size_y)) * tile_size_y)
	
	if(current_item != null and can_place == true and Input.is_action_pressed("mb_left")):
		var new_item = current_item.instantiate()
		
	elif(current_item != null and can_place == true and Input.is_action_just_released("mb_left")):
		var new_item = current_item.instantiate()
		new_item.global_position = get_global_mouse_position()
		level.add_child(new_item)
		current_item = null
		
		#add the character info pop up when release
		var scene = preload("res://Scenes/character_info.tscn").instantiate()
		var root = get_tree().get_root()
		root.add_child(scene)
	pass
