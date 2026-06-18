class_name IconMapper
extends Node

var keyboard_icons: Dictionary[String, String] = {
	"move_up": "res://assets/UI/ui_button_icons/keyboard/W.svg",
	"move_left": "res://assets/UI/ui_button_icons/keyboard/A.svg",
	"move_right": "res://assets/UI/ui_button_icons/keyboard/D.svg",
	"move_down": "res://assets/UI/ui_button_icons/keyboard/S.svg",
	"attack": "res://assets/UI/ui_button_icons/keyboard/O.svg",
	"roll": "res://assets/UI/ui_button_icons/keyboard/P.svg",
	"interact": "res://assets/UI/ui_button_icons/keyboard/R.svg",
	"pause": "res://assets/UI/ui_button_icons/keyboard/ESC.svg",
	"inventory": "res://assets/UI/ui_button_icons/keyboard/E.svg",
	"skip_dialogue": "res://assets/UI/ui_button_icons/keyboard/O.svg",
	"ui_accept": "res://assets/UI/ui_button_icons/keyboard/O.svg",
	"ui_cancel": "res://assets/UI/ui_button_icons/keyboard/P.svg",
	"ui_select": "res://assets/UI/ui_button_icons/keyboard/O.svg"
}

var playstation_icons: Dictionary[String, String] = {
	"move_up": "res://assets/UI/ui_button_icons/playstation/D-Pad-Up.svg",
	"move_left": "res://assets/UI/ui_button_icons/playstation/D-Pad-Left.svg",
	"move_right": "res://assets/UI/ui_button_icons/playstation/D-Pad-Right.svg",
	"move_down": "res://assets/UI/ui_button_icons/playstation/D-Pad-Down.svg",
	"attack": "res://assets/UI/ui_button_icons/playstation/Square-Button.svg",
	"roll": "res://assets/UI/ui_button_icons/playstation/R1.svg",
	"interact": "res://assets/UI/ui_button_icons/playstation/Cross-Button.svg",
	"pause": "res://assets/UI/ui_button_icons/playstation/Start.svg",
	"inventory": "res://assets/UI/ui_button_icons/playstation/Select.svg",
	"skip_dialogue": "res://assets/UI/ui_button_icons/playstation/Cross-Button.svg",
	"ui_accept": "res://assets/UI/ui_button_icons/playstation/Cross-Button.svg",
	"ui_cancel": "res://assets/UI/ui_button_icons/playstation/Circle-Button.svg",
	"ui_select": "res://assets/UI/ui_button_icons/playstation/Cross-Button.svg"
}

var xbox_icons: Dictionary[String, String] = {
	"move_up": "res://assets/UI/ui_button_icons/xbox/D-Pad-Up.svg",
	"move_left": "res://assets/UI/ui_button_icons/xbox/D-Pad-Left.svg",
	"move_right": "res://assets/UI/ui_button_icons/xbox/D-Pad-Right.svg",
	"move_down": "res://assets/UI/ui_button_icons/xbox/D-Pad-Down.svg",
	"attack": "res://assets/UI/ui_button_icons/xbox/X-Button.svg",
	"roll": "res://assets/UI/ui_button_icons/xbox/RB.svg",
	"interact": "res://assets/UI/ui_button_icons/xbox/A-Button.svg",
	"pause": "res://assets/UI/ui_button_icons/xbox/Start.svg",
	"inventory": "res://assets/UI/ui_button_icons/xbox/Select.svg",
	"skip_dialogue": "res://assets/UI/ui_button_icons/xbox/A-Button.svg",
	"ui_accept": "res://assets/UI/ui_button_icons/xbox/A-Button.svg",
	"ui_cancel": "res://assets/UI/ui_button_icons/xbox/B-Button.svg",
	"ui_select": "res://assets/UI/ui_button_icons/xbox/A-Button.svg"
}

func parse_input_text(text: String, size: int = 24) -> String:
	var parsed_text = text
	var dict_icons: Dictionary
	
	if InputManager.active_input_source == InputManager.InputSource.KEYBOARD:
		dict_icons = keyboard_icons
	else:
		var active_controller_id = InputManager.controller_manager.get_active_controller()
		var controller_type = InputManager.controller_manager.connected_controllers[active_controller_id].type
		
		match controller_type:
			InputManager.controller_manager.ControllerType.PLAYSTATION:
				dict_icons = playstation_icons
			InputManager.controller_manager.ControllerType.XBOX:
				dict_icons = xbox_icons
	
	for action in dict_icons.keys():
		var tag = "[" + action + "]"
		if tag in parsed_text:
			var img_bbcode = "[img=" + str(size) + "]" + dict_icons[action] + "[/img]"
			parsed_text = parsed_text.replace(tag, img_bbcode)
	return parsed_text
