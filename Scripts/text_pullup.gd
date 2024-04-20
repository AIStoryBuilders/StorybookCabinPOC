extends Control

signal get_prompt(prompt)

@export var menu_size = 0.45
@export var lerp_speed = 0.2

@onready var promptLine = $VBoxContainer/NinePatchRect/LineEdit

var _popped_up = false
var _up_anchor = Vector2(1 - menu_size, 1)
var _down_anchor = Vector2(1, 1 + menu_size)
var _target_anchor = _down_anchor
var text_to_display = ""
var WebApplicationURL = ""
var paramUserName = ""
var paramHTTPToken = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	
	#Define the variables
	
	var cmdline_args = OS.get_cmdline_args()
	#var FirstArguments = "--WebApplicationURL=https://blazorgodot.azurewebsites.net/,--UserName=TestUser,--HTTPToken=1234ABCD#"
	var FirstArguments = cmdline_args[0]
	
	var FirstArgumentsArray = FirstArguments.split(",")
	
	#Get all for text_to_display
	for arg in FirstArgumentsArray:
		text_to_display += arg + ", "
	
	#Remove the last comma and space if there are any arguments
	if FirstArgumentsArray.size() > 0:
		text_to_display = text_to_display.substr(0, text_to_display.length() - 2)
	
	#Set UserName and HTTPToken	
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
	
	var user_name = paramUserName
	var http_token = paramHTTPToken
	var user_text = promptLine.text
	var http_request = $HTTPRequest
	
	var url = WebApplicationURL + "ReceiveCallFromGodot/"
	var body_dict = {
		"userName": user_name,
		"hTTPToken": http_token,
		"userText": user_text
	}
	
	var json = JSON.new()
	var body = json.stringify(body_dict)
	var headers = ["Content-Type: application/json"]
	http_request.request_completed.connect(self._on_request_completed)
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		print("Error sending request: ", error)
		
	print("User Text: " + user_text)
	
func _on_request_completed(result, response_code, headers, body):
	var BlazorResponseLabelControl = $VBoxContainer/NinePatchRect/BlazorResponseLabel
	
	if response_code == 200:
		var body_string = body.get_string_from_utf8()
		print("Raw response body: ", body_string)
		BlazorResponseLabelControl.text = "Blazor Response: " + body_string
		
		var json = JSON.new()
		var parsed_data = JSON.parse_string(body_string)

		print("Parsed JSON data: ", parsed_data)
		
		if typeof(parsed_data) == TYPE_DICTIONARY and "message" in parsed_data:
			var message = parsed_data["message"]
			print("Message: ", message)			
			BlazorResponseLabelControl.text = "Blazor Response: " + message
		else:
			print("Unexpected JSON structure")

	pass # Replace with function body.



