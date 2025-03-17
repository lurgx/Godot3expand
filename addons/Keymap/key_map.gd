tool
extends Button
class_name Keymap  # Nombre de la clase para usar en el editor

export var texting = "PRESS KEY PLEASE" setget te1 #texto al esperar una telca
export var textingend = "KEY " setget te2 #texto al aver editado una tecla
export var keyremap = "A" setget leader #tecla que se quedo mas el texto de textinend (KEY A)
export(int,0,3) var joypad = 0 setget joy#a que control le pertenece este bootnsi se conecta
export var autoload = "" # singleton(autoload) a buscar para obtener el mapeo
export var variable_array = ""#nombre del array  en el singleton para obtener el valor del mapeo 
export var valueinarray = 0#posicion de la tecla dentro del array 
export var unique_button_joypad = false setget unique#solo usar telcas de joypad(permite que otro jugador use el teclado)
export var use_right_joy = false setget joyright # usar el joystick derecho tambien 



var node = Node.new()
var key 
var maping = false
var st = ""
var code = 0
var ax_v = 0
var ax = 0
var obj = null
var more = 0
var inn = 0
var input = [["KEY A",0,"A",0],["KEY D",0,"D",0]]


func joyright(jo):
	use_right_joy = jo

func unique(va):
	unique_button_joypad = va

func joy(j):
	joypad = j

func leader(v):
	keyremap = v

func te1(tt):
	texting = tt

func te2(t2):
	textingend = t2


func map():
	node = get_tree().root.get_node(str(autoload))
	input = node.get(str(variable_array))
	text = texting
	maping = true



func _ready():
	enabled_focus_mode = Control.FOCUS_NONE
	connect("pressed",self,"map")



func _input(event):#OBTENER TECLAS, BUTTON O AXIS

	if maping:
		if event is InputEventKey:
			
			print("Key remap to ",OS.get_scancode_string(event.scancode)," unicode ",event.scancode)
			st = OS.get_scancode_string(event.scancode)
			code = event.scancode
			obj = event
			inn = 0

			input[valueinarray][0] = st
			input[valueinarray][1] = event.scancode
			input[valueinarray][2] = keyremap


			_change()

		elif event is InputEventJoypadButton:
			event.device = joypad  # Asignar el ID del mando
			print("Key remap to ",Input.get_joy_button_string(event.button_index)  ,event.button_index)
			st = Input.get_joy_button_string(event.button_index)
			code = event.button_index
			obj = event
			inn = 1
			
			input[valueinarray][0] = st
			input[valueinarray][2] = keyremap
			input[valueinarray][3] = code
#			input[valueinarray][4] = input[valueinarray][4]

			_change()




		elif event is InputEventJoypadMotion:
			event.device = joypad
			code = event.axis
			ax_v = event.axis_value
			ax = event.axis
			obj = event
			inn = 2

			if code == JOY_AXIS_0:  # Eje X del stick izquierdo
				if ax_v < -0.5:
					st = "JOY_Lx -1"
					more = -1
					ax = 0
				elif ax_v > 0.5:
					st = "JOY_Lx +1"
					more = 1
					ax = 0
			elif code == JOY_AXIS_1:  # Eje Y del stick izquierdo
				if ax_v < -0.5:
					st = "JOY_Ly -1"
					ax = 1
					more = -2
				elif ax_v > 0.5:
					st = "JOY_Ly +1"
					more = 2
					ax = 1


			if use_right_joy == true:

				if code == JOY_AXIS_2:  # Eje X del stick derecho
					
					if ax_v < -0.5:
						st = "JOY_Rx -1"
						more = -1
						ax = 2
					elif ax_v > 0.5:
						st = "JOY_Rx +1"
						more = 1
						ax = 2
				elif code == JOY_AXIS_3:  # Eje Y del stick derecho
					if ax_v < -0.5:
						st = "JOY_Ry -1"
						more = -2
						ax = 3
					elif ax_v > 0.5:
						st = "JOY_Ry +1"
						more = 2
						ax = 3






			if more != 0:
				_change()




func _change():#CAMBIAR VALOR Y MAPEAR
	if inn == 0:
		maping = false
		InputMap.action_erase_events(keyremap)
		InputMap.action_add_event(keyremap,obj)
		text = str(textingend,st)
		code = 0
		st = ""
		obj = null
		inn = 0

	if inn == 1:
		maping = false
		if !InputMap.action_has_event(keyremap,obj):
			if unique_button_joypad == true:
				InputMap.action_erase_events(keyremap)
			InputMap.action_add_event(keyremap,obj)
		text = str(st)
		code = 0
		st = ""
		obj = null
		inn = 0

	if inn == 2:
		maping = false

		var motion_event = null
		if more == -1:
			motion_event = InputEventJoypadMotion.new()
			motion_event.axis = ax  
			motion_event.axis_value = -1.0
			if ax == 0 or ax == 1:
				input[valueinarray][4] = -1
			elif ax == 2 or ax == 3:
				input[valueinarray][5] = -1
		elif more == 2:
			motion_event = InputEventJoypadMotion.new()
			motion_event.axis = ax  
			motion_event.axis_value = 1.0  
			if ax == 0 or ax == 1:
				input[valueinarray][4] = 2
			elif ax == 2 or ax == 3:
				input[valueinarray][5] = 2
		elif more == 1:
			motion_event = InputEventJoypadMotion.new()
			motion_event.axis = ax 
			motion_event.axis_value = 1.0 
			if ax == 0 or ax == 1: 
				input[valueinarray][4] = 1
			elif ax == 2 or ax == 3:
				input[valueinarray][5] = 1
		elif more == -2:
			motion_event = InputEventJoypadMotion.new()
			motion_event.axis = ax  
			motion_event.axis_value = -1.0  
			if ax == 0 or ax == 1:
				input[valueinarray][4] = -2
			elif ax == 2 or ax == 3:
				input[valueinarray][5] = -2

		# Si se creó un evento de movimiento, asignar el `device` y agregarlo
		if motion_event:
			motion_event.device = joypad
#			if !InputMap.has_action(keyremap):
#				InputMap.add_action(keyremap)
			if !InputMap.action_has_event(keyremap, motion_event):
				InputMap.action_add_event(keyremap, motion_event)


		text = str(textingend,st)
		code = 0
		st = ""
		ax_v = 0
		obj = null
		inn = 0
		more = 0
	node.set(str(variable_array),input)




func _maping():#Se puede llamar al inicio de una scena para mapear los botones
	node = get_tree().root.get_node(str(autoload))
	input = node.get(str(variable_array))

	var joybutton = false
	var nam = input[valueinarray][0]  # Nombre de la tecla
	var val = input[valueinarray][1]  # Código de la tecla
	var action = input[valueinarray][2]  # Acción a modificar
	var valbutton = input[valueinarray][3]  # Código de la boton en joy

	# Crear el evento de entrada con la tecla correspondiente
	if Input.get_connected_joypads().count(0)>=1:
		joybutton = true

	var event = InputEventKey.new()
	event.scancode = val  

	# Eliminar eventos previos y agregar el nuevo mapeo
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)


	var ev = InputEventJoypadButton.new()
	ev.button_index = valbutton

	# Eliminar eventos previos y agregar el nuevo mapeo
	if unique_button_joypad == true:
		InputMap.action_erase_events(action)
	InputMap.action_add_event(action, ev)



#AGREGAR EL JOYSTICK SI SE CONFIGURO 
	var xi = input[valueinarray][4]
	var xir = input[valueinarray][5]

	if xi != 0:
		var eve = InputEventJoypadMotion.new()
		var motion_event = null
		if xi == -1:
			motion_event = InputEventJoypadMotion.new()
			motion_event.axis = 0  
			motion_event.axis_value = -1.0  
			input[valueinarray][3] = -1
		elif xi == 2:
			motion_event = InputEventJoypadMotion.new()
			motion_event.axis = 1  
			motion_event.axis_value = 1.0  
			input[valueinarray][3] = 2
		elif xi == 1:
			motion_event = InputEventJoypadMotion.new()
			motion_event.axis = 0  
			motion_event.axis_value = 1.0  
			input[valueinarray][3] = 1
		elif xi == -2:
			motion_event = InputEventJoypadMotion.new()
			motion_event.axis = 1  
			motion_event.axis_value = -1.0  
			input[valueinarray][3] = -2

		# Si se creó un evento de movimiento, asignar el `device` y agregarlo
		if motion_event:
			motion_event.device = joypad
			if !InputMap.action_has_event(keyremap, motion_event):
				InputMap.action_add_event(keyremap, motion_event)

	if xir != 0 and use_right_joy:
		var eve = InputEventJoypadMotion.new()
		var motion_event = null
		if xi == -1:
			motion_event = InputEventJoypadMotion.new()
			motion_event.axis = 2  
			motion_event.axis_value = -1.0  
			input[valueinarray][4] = -1
		elif xi == 2:
			motion_event = InputEventJoypadMotion.new()
			motion_event.axis = 3  
			motion_event.axis_value = 1.0  
			input[valueinarray][4] = 2
		elif xi == 1:
			motion_event = InputEventJoypadMotion.new()
			motion_event.axis = 2  
			motion_event.axis_value = 1.0  
			input[valueinarray][4] = 1
		elif xi == -2:
			motion_event = InputEventJoypadMotion.new()
			motion_event.axis = 3  
			motion_event.axis_value = -1.0  
			input[valueinarray][4] = -2

		# Si se creó un evento de movimiento, asignar el `device` y agregarlo
		if motion_event:
			motion_event.device = joypad
			if !InputMap.action_has_event(keyremap, motion_event):
				InputMap.action_add_event(keyremap, motion_event)

	text = str(textingend,nam)


