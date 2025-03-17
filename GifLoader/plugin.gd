tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("GifLoader", "Node2D", preload("res://addons/GifLoader/gif_loader.gd"), null)

func _exit_tree():
	remove_custom_type("GifLoader")
