extends Control

signal get_prompt(prompt)

@export var menu_size = 0.45
@export var lerp_speed = 0.2

@onready var promptLine = $VBoxContainer/NinePatchRect/LineEdit
@onready var message_container = $VBoxContainer/NinePatchRect/ScrollContainer/VBoxContainer

var tileMap = preload("res://Scenes/TileMap.gd").new()

var _popped_left = false
var _left_anchor = Vector2(1 - menu_size, 1)
var _right_anchor = Vector2(1, 1)
var _target_anchor = _right_anchor
var text_to_display = ""
var WebApplicationURL = ""
var paramUserName = ""
var paramHTTPToken = ""
var tileMapDic = {}
var CharDic = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	var cmdline_args = OS.get_cmdline_args()
	#var FirstArguments = "--WebApplicationURL=https://blazorgodot.azurewebsites.net/,--UserName=TestUser,--HTTPToken=1234ABCD#"
	var FirstArguments = cmdline_args[0]
	var FirstArgumentsArray = FirstArguments.split(",")
	
	# Get all for text_to_display
	for arg in FirstArgumentsArray:
		text_to_display += arg + ", "
	
	# Remove the last comma and space if there are any arguments
	if FirstArgumentsArray.size() > 0:
		text_to_display = text_to_display.substr(0, text_to_display.length() - 2)
	
	# Set UserName and HTTPToken    
	for i in range(FirstArgumentsArray.size()):
		if FirstArgumentsArray[i].begins_with("--WebApplicationURL"):
			var AllKeyParts = FirstArgumentsArray[i].split('=', true, 1)
			WebApplicationURL = AllKeyParts[1]
		if FirstArgumentsArray[i].begins_with("--UserName"):
			var AllKeyParts = FirstArgumentsArray[i].split('=', true, 1)
			paramUserName = AllKeyParts[1]
		if FirstArgumentsArray[i].begins_with("--HTTPToken"):
			var AllKeyParts = FirstArgumentsArray[i].split('=', true, 1)
			paramHTTPToken = AllKeyParts[1]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	anchor_left = lerp(anchor_left, _target_anchor.x, lerp_speed)
	anchor_right = lerp(anchor_right, _target_anchor.y, lerp_speed)

func _on_texture_button_pressed():
	if !_popped_left:
		_target_anchor = _left_anchor
	else:
		_target_anchor = _right_anchor
	_popped_left = !_popped_left

func _on_button_pressed():
	var user_name = paramUserName
	var http_token = paramHTTPToken
	var user_text = promptLine.text
	var http_request = $HTTPRequest
	
	var game_board = Global.GlobalDic
	var character_info = Global.CharacterDic
	
	var url = WebApplicationURL + "ReceiveCallFromGodot/"
	var body_dict = {
		"userName": user_name,
		"hTTPToken": http_token,
		"userText": user_text,
		"gameBoard": game_board,
		"characterInfo": character_info
	}
	
	var json = JSON.new()
	var body = json.stringify(body_dict)
	var headers = ["Content-Type: application/json"]
	http_request.request_completed.connect(self._on_request_completed)
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		print("Error sending request: ", error)
	else:
		# Display the user's message in the chat area
		add_message(user_text, true)

func _on_request_completed(result, response_code, headers, body):

	if response_code == 200:
		var body_string = body.get_string_from_utf8()
		print("Raw response body: ", body_string)
		
		var json = JSON.new()
		var parsed_data = JSON.parse_string(body_string)
		
		if typeof(parsed_data) == TYPE_DICTIONARY and "message" in parsed_data:
			var message = parsed_data["message"]
			print("Message: ", message)            
			
			# Display the AI's response in the chat area
			add_message(message, false)
		else:
			print("Unexpected JSON structure")

func add_message(text: String, is_user: bool):
	var message_label = Label.new()
	message_label.text = text
	if is_user:
		message_label.add_theme_color_override("font_color", Color(0.3, 0.3, 1)) # User color
	else:
		message_label.add_theme_color_override("font_color", Color(0.1, 0.8, 0.1)) # AI color
		
	message_container.add_child(message_label)
	#scroll_to_bottom()

func scroll_to_bottom():
	var scroll_container = $VBoxContainer/NinePatchRect/ScrollContainer
	scroll_container.scroll_vertical = scroll_container.get_v_scrollbar().max_value
