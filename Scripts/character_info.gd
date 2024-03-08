extends CanvasLayer

signal get_name(name)
signal get_age(age)
signal get_gender(gender)
signal get_description(description)

@onready var nameLine = $TextureRect/LineEdit1
@onready var ageLine = $TextureRect/LineEdit2
@onready var genderLine = $TextureRect/LineEdit3
@onready var descriptionLine = $TextureRect/LineEdit4

"""
test
var _name: String
var _age: int
var _gender: String
var _description: String
"""
#var textBoxes : Array = [nameLine, ageLine, genderLine, desriptionLine]
var currentTextBoxIndex = 0
const NUM_TEXT_BOXES = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	nameLine.grab_focus()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("enter"):
		focus_next()
		
func focus_next():
	currentTextBoxIndex += 1
	if currentTextBoxIndex >= NUM_TEXT_BOXES:
		return
	var nextTextBox = get_node("TextureRect/LineEdit" + str(currentTextBoxIndex + 1))
	nextTextBox.grab_focus()


func _on_button_pressed():
	emit_signal("get_name", nameLine.text)
	emit_signal("get_age", ageLine.text)
	emit_signal("get_gender", genderLine.text)
	emit_signal("get_description", descriptionLine.text)
	queue_free()

func _on_get_name(name):
	print(name)

func _on_get_age(age):
	print(age)

func _on_get_gender(gender):
	print(gender)

func _on_get_description(description):
	print(description)

"""
func _init(nameLine: String, ageLine: int, genderLine: String, descriptionLine: String):
	_name = nameLine
	_age = ageLine
	_gender = genderLine
	_description = descriptionLine
"""
