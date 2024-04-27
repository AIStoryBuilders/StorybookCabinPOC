extends TileMap

var GridSizeX = 19
var GridSizeY = 13
var whatLayer = 0
var Dic = {}

@onready var tilemap: TileMap = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for y in range(-6, 6):
		for x in range(-9, 10):
			Dic[str(Vector2(x, y))] = {
				"Type": getTileType(Vector2(x, y))
			}
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
	
	
func getTileType(position: Vector2) -> String:
	
	is_tile_empty(position)
	if whatLayer == 0: #is Empty
		return "empty"
	elif whatLayer == 1: #is Wall
		return "wall"
	elif whatLayer == 2: #has object
		return "object"
	else:
		return "unidentified"
		
