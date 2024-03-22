extends Control

signal get_prompt(prompt)

@export var menu_size = 0.45
@export var lerp_speed = 0.2

@onready var promptLine = $VBoxContainer/NinePatchRect/LineEdit

var _popped_up = false
var _up_anchor = Vector2(1 - menu_size, 1)
var _down_anchor = Vector2(1, 1 + menu_size)
var _target_anchor = _down_anchor

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	anchor_top = lerp(anchor_top, _target_anchor.x, lerp_speed)
	anchor_bottom = lerp(anchor_top, _target_anchor.y, lerp_speed)
	pass


func _on_texture_button_pressed():
	if !_popped_up:
		_target_anchor = _up_anchor
	else:
		_target_anchor = _down_anchor
	_popped_up = !_popped_up
	pass # Replace with function body.


func _on_button_pressed():
	emit_signal("get_prompt", promptLine.text)
	pass # Replace with function body.

func _on_get_prompt(prompt):
	print(prompt)
	pass # Replace with function body.
