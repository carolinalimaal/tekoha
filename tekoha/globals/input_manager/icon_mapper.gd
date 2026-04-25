class_name IconMapper
extends Node

@export var keyboard_icons: Dictionary[String, Texture2D]
@export var controller_icons: Dictionary[String, Texture2D]

func parse_input_text(text: String, size: int = 24) -> String:
	var parsed_text = text
	var dict_icons = keyboard_icons if InputManager.active_input_source == InputManager.InputSource.KEYBOARD else controller_icons
	
	for action in dict_icons.keys():
		var tag = "[" + action + "]"
		if tag in parsed_text:
			var img_bbcode = "[img=" + str(size) + "]" + dict_icons[action].resource_path + "[/img]"
			parsed_text = parsed_text.replace(tag, img_bbcode)
	return parsed_text
