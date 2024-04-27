extends Node2D

var tilemap

# Called when the node enters the scene tree for the first time.
func _ready():
	var tilemap = $TileMap
	
	getMapstuff()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func getMapstuff():
	var p = tilemap.get_cell_atlas_coords(0, 1,1, false)
	print(p)
