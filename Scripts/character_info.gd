extends CanvasLayer

signal get_name(name)
signal get_age(age)
signal get_gender(gender)
signal get_description(description)
signal character_info_confirmed

@onready var nameLine = $TextureRect/LineEdit1
@onready var ageLine = $TextureRect/LineEdit2
@onready var genderLine = $TextureRect/LineEdit3
@onready var descriptionLine = $TextureRect/LineEdit4

var character_info = {}
var character_position = Vector2.ZERO

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
	character_info["name"] = nameLine.text
	character_info["age"] = ageLine.text.to_int()
	character_info["gender"] = genderLine.text
	character_info["description"] = descriptionLine.text
	
	for character_instance in Global.pending_character_data.keys():
		var position = Global.pending_character_data[character_instance]
		
		# Add character info to the global dictionary with the position as the key
		var position_key = str(position)
		Global.CharacterDic[position_key] = character_info
		print("Character added: ", Global.CharacterDic)
		
		print("Position: ", position)
		
		# Set the name of the character instance
		character_instance.name = character_info["name"]
		
		# Remove from pending data after processing
		Global.pending_character_data.erase(character_instance)
	
	queue_free()
