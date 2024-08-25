# Global.gd
extends Node

var character_position: Vector2
var GlobalDic = {}
var CharacterDic = {}
var pending_character_data = {}

func _ready():
	# Initialization here
	character_position = Vector2()
	GlobalDic = {}
	CharacterDic = {}
