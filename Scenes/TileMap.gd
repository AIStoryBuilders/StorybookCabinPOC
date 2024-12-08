extends TileMap

var GridSizeX = 19
var GridSizeY = 13
var whatLayer = 0
var Dic = {}

@onready var tilemap: TileMap = self
@onready var level = get_node("/root/Main/Level")

var character
var tile_size = Vector2(16, 16)

# Called when the node enters the scene tree for the first time.
func _ready():
	for y in range(-6, 6):
		for x in range(-9, 10):
			var position = Vector2(x, y)
			var tile_info = getTileType(position)
			
			var tile_global_postion = tilemap.map_to_local(position)
			
			Dic[str(tile_global_postion)] = {
				"Type": tile_info["type"],
				"description": tile_info["description"]
			}
			
	Global.GlobalDic = Dic
	print(Dic)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func is_tile_empty(position: Vector2) -> bool:
	
	var tile_id = tilemap.get_cell_source_id(1, position) #checks if tile is a wall
	if tile_id != -1:
		whatLayer = 1 
		return false
	
	tile_id = tilemap.get_cell_source_id(2, position) #checks if tile is object
	if tile_id != -1:
		whatLayer = 2
		return false
	
	whatLayer = 0
	return true #is Empty
	
	
func getTileType(position: Vector2) -> Dictionary:
	is_tile_empty(position)
	var result = {
		"type": "",
		"description": ""
	}
	if whatLayer == 0: # is Empty
		result["type"] = "empty"
		result["description"] = "Empty area a character can occupy"
	elif whatLayer == 1: # is Wall
		result["type"] = "wall"
		result["description"] = "A wall"
	elif whatLayer == 2: # has Object
		result["type"] = "object"
		result["description"] = getObjectDescription(position)
	else:
		result["type"] = "unidentified"
	
	return result
	
func getObjectDescription(position: Vector2) -> String:
	var tile_id = tilemap.get_cell_source_id(2, position)
	if tile_id != -1:
		var tile_set = tilemap.tile_set
		

		var tile_data = tilemap.get_cell_tile_data(2, position)
		var tileDescription = tile_data.get_custom_data_by_layer_id(0)
		return tileDescription
	return "tile_id error"

	
func tile_to_world(tile_position: Vector2) -> Vector2:
	return tile_position * tile_size + tile_size / 2
	
