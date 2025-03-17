tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("Keymap", "Node2D", preload("res://addons/Keymap/key_map.gd"), null)

func _exit_tree():
	remove_custom_type("Keymap")
