extends TabContainer

@onready var object_cursor = get_node("/root/Main/Editor_Object")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mouse_entered():
	object_cursor.can_place = false
	pass # Replace with function body.
	
func _on_mouse_exited():
	object_cursor.can_place = true
	pass # Replace with function body.
