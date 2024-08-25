extends TextureRect

@export var this_scene : PackedScene

@onready var object_cursor = get_node("/root/Main/Editor_Object")
@onready var cursor_sprite = get_node("/root/Main/Editor_Object/Sprite")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _item_clicked(event):
	if(event is InputEvent):
		if(event.is_action_pressed("mb_left")):
			object_cursor.current_item = this_scene
			cursor_sprite.texture = texture
		elif (event.is_action_released("mb_left")):
			object_cursor.current_item = this_scene
			cursor_sprite.texture = null
	pass # Replace with function body.
