tool
extends Node
class_name OggLoader  # Cambié esto para que no se confunda con AudioStreamOGGVorbis

export(String, FILE, "*.ogg") var path_song setget set_path_song
export(float, -80, 24.0) var volume = 1.0 setget set_volume
export(float, 0.01, 4.0) var pitch = 1.0 
export(bool) var autoplay = false
var bus := "Master" setget set_bus  # Ahora se puede modificar
var player: AudioStreamPlayer





func set_bus(new_bus):
	if new_bus in get_bus_list():
		bus = new_bus
		if player:
			player.bus = bus
	else:
		print("❌ Error: Bus no válido seleccionado")

func get_bus_list() -> Array:
	var buses = []
	for i in range(AudioServer.bus_count):
		buses.append(AudioServer.get_bus_name(i))
	return buses

func _get_property_list():
	var properties = []
	
	# Agregar una propiedad dinámica de tipo Enum con los buses disponibles
	properties.append({
		"name": "bus",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": ",".join(get_bus_list())
	})

	return properties

func set_path_song(new_path):
	path_song = new_path
	load_audio(new_path)

func load_audio(new_path):
	if new_path == "":
		return
	var file = File.new()
	if file.open(new_path, File.READ) == OK:
		var data = file.get_buffer(file.get_len())
		file.close()

		var audio_stream = AudioStreamOGGVorbis.new()
		audio_stream.data = data
		player.stream = audio_stream

		print("🎵 Canción cargada:", path_song)

		if autoplay:
			play()
	else:
		print("❌ Error al abrir el archivo .ogg:", new_path)

func play():
	if player.stream:
		player.bus = bus
		player.pitch_scale = pitch
		player.play()

func stop():
	player.stop()

func pause():
	player.stream_paused = true

func resume():
	player.stream_paused = false


func set_volume(value):
	volume = value
	if player:
		player.volume_db = linear2db(volume)


func _ready():
	if not Engine.editor_hint:
		bus = "Master"
		player = AudioStreamPlayer.new()
		add_child(player)
		player.bus = bus
		set_volume(volume)

	if path_song != "":
		load_audio(path_song)
