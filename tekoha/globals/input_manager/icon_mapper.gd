class_name IconMapper
extends Node

var keyboard_icons: Dictionary[String, String] = {
	"move_up": "res://assets/UI/ui_button_icons/keyboard/W.svg",
	"move_left": "res://assets/UI/ui_button_icons/keyboard/A.svg",
	"move_right": "res://assets/UI/ui_button_icons/keyboard/D.svg",
	"move_down": "res://assets/UI/ui_button_icons/keyboard/S.svg",
	"attack": "res://assets/UI/ui_button_icons/keyboard/Mouse-Left-Click.svg",
	"roll": "res://assets/UI/ui_button_icons/keyboard/Mouse-Right-Click.svg",
	"interact": "res://assets/UI/ui_button_icons/keyboard/R.svg",
	"pause": "res://assets/UI/ui_button_icons/keyboard/ESC.svg",
	"inventory": "res://assets/UI/ui_button_icons/keyboard/E.svg",
	"skip_dialogue": "res://assets/UI/ui_button_icons/keyboard/Mouse-Left-Click.svg",
	"ui_accept": "res://assets/UI/ui_button_icons/keyboard/Space.svg",
	"ui_cancel": "res://assets/UI/ui_button_icons/keyboard/ESC.svg",
	"ui_select": "res://assets/UI/ui_button_icons/keyboard/Space.svg"
}

var controller_icons: Dictionary[String, String] = {
	"move_up": "res://assets/UI/ui_button_icons/controller/D-Pad-Up.svg",
	"move_left": "res://assets/UI/ui_button_icons/controller/D-Pad-Left.svg",
	"move_right": "res://assets/UI/ui_button_icons/controller/D-Pad-Right.svg",
	"move_down": "res://assets/UI/ui_button_icons/controller/D-Pad-Down.svg",
	"attack": "res://assets/UI/ui_button_icons/controller/X-Button.svg",
	"roll": "res://assets/UI/ui_button_icons/controller/RB.svg",
	"interact": "res://assets/UI/ui_button_icons/controller/A-Button.svg",
	"pause": "res://assets/UI/ui_button_icons/controller/Start.svg",
	"inventory": "res://assets/UI/ui_button_icons/controller/Select.svg",
	"skip_dialogue": "res://assets/UI/ui_button_icons/controller/A-Button.svg",
	"ui_accept": "res://assets/UI/ui_button_icons/controller/A-Button.svg",
	"ui_cancel": "res://assets/UI/ui_button_icons/controller/B-Button",
	"ui_select": "res://assets/UI/ui_button_icons/controller/A-Button.svg"
}

func parse_input_text(text: String, size: int = 24) -> String:
	var parsed_text = text
	var dict_icons = keyboard_icons if InputManager.active_input_source == InputManager.InputSource.KEYBOARD else controller_icons
	
	for action in dict_icons.keys():
		var tag = "[" + action + "]"
		if tag in parsed_text:
			var img_bbcode = "[img=" + str(size) + "]" + dict_icons[action] + "[/img]"
			parsed_text = parsed_text.replace(tag, img_bbcode)
	return parsed_text
