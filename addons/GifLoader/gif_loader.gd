tool
extends Node2D
class_name GifLoader  # Nombre de la clase para usar en el editor


var imgcount = 0
var save_path = ""
var imgs = []
var create_gif = true
var re = false
var ok = false


export(String) var name_gif = "" setget ch_n
export var loadg = false setget loadgg
export(float, 0.1, 8) var speed_scale = 1
export var play = false setget playing

export var flip_h = false setget fliph
export var flip_v = false setget flipv
export var centered = true setget cen


var animated_sprite = AnimatedSprite.new()
var sprite_frames = SpriteFrames.new()

func _ready():
	add_child(animated_sprite)
	if name_gif != "":
		set_path_gif()
		cen(centered)
		


func set_path_gif():
	var game_folder = OS.get_executable_path().get_base_dir()
	var gif_absoluta = str(game_folder, "/lgif/", name_gif,".gif")
	var output_folder = str(game_folder, "/lgif/",name_gif)
#	var exe_path = str(game_folder, "/lgif/main.exe")
	var exe_path = str(game_folder, "/lgif/de.bat")


#CHECAR DIRECCION Y CHECAR SI EXISTEN IMAGENES
	var di = Directory.new()
	if !di.dir_exists(str(output_folder)):
		di.make_dir(str(output_folder))
		re = true
	else:
		var dir = Directory.new()
		if dir.open(output_folder) == OK:#checar archivos y carpetas
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if dir.current_is_dir():
					if !file_name.begins_with(".") and !file_name.begins_with(".,"):
						pass
				else:
					if file_name.begins_with("an"):
						create_gif = false
				file_name = dir.get_next()
		else:
			pass

	yield(get_tree(), "idle_frame")
	# Ejecutar el comando con los argumentos si no existen
	if create_gif:
		var resultado = OS.execute(exe_path, [gif_absoluta, output_folder], false)

		if resultado == 0:
			pass
#			print("✅ GIF procesado correctamente")
		else:
			print("❌ Hubo un error al ejecutar el comando.")


	yield(get_tree(), "idle_frame")
	_lo(output_folder)

func _lo(path):
	save_path = str(path, "/")
	var dir = Directory.new()
	if dir.open(save_path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				imgcount += 1
			file_name = dir.get_next()
	load_image_sequence()

func load_image_sequence():

	animated_sprite.global_position = Vector2(global_position.x,global_position.y)
	animated_sprite.speed_scale = speed_scale

	animated_sprite.name = "ani"
	animated_sprite.visible = visible
	animated_sprite.modulate = modulate
	animated_sprite.self_modulate = self_modulate

	animated_sprite.z_as_relative = z_as_relative
	animated_sprite.show_behind_parent= show_behind_parent
	animated_sprite.light_mask = light_mask
	animated_sprite.material = material
	animated_sprite.frames = sprite_frames
	
	ok = true
	playing(play)

	for i in range(imgcount):
		imgs.append("an" + str(i+1))
	
	yield(get_tree(), "idle_frame")
	for i in range(imgs.size()):
		var texture = ImageTexture.new()
		var image = Image.new()
		if image.load(str(save_path, imgs[i], ".png")) == OK:
			texture.create_from_image(image)
			sprite_frames.add_frame("default", texture)
	
	animated_sprite.animation = "default"
	
	if re == true:
		set_path_gif()
		re = false


func cen(b):
	animated_sprite.centered = b
	centered = b

func ch_n(ng):
	name_gif = ng

func loadgg(tr):
	if tr == true:
		set_path_gif()
		loadg = false

func playing(p):
	play = p
	if play:
		if sprite_frames.has_animation("default"):
			if ok == true:
				animated_sprite.play("default")
	else:
			animated_sprite.stop()

func fliph(v):
	animated_sprite.flip_h = v
	flip_h = v


func flipv(v):
	animated_sprite.flip_v = v
	flip_v = v
