tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("OggLoader", "Node", preload("res://addons/OggLoader/audio_loader.gd"), null)  # Asegúrate de que se llame OggLoader
	

func _exit_tree():
	remove_custom_type("OggLoader")
