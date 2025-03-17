extends Node

var input1 = [   ["KEY Z",90,"A",14,-1,-1]     ,    ["KEY D",0,"D",-1,1,1]           ,["KEY W",0,"W",-1,-2,-2],["KEY S",0,"S",-1,2,2]]
			#[[NOMBRE,VALOR,ACCION,BOTONJOY,AXISleft,AXISright]]
var input2 = [["KEY A",65,"A",14,-1,-1],["KEY D",0,"D",-1,1,1],["KEY W",0,"W",-1,-2,-2],["KEY S",0,"S",-1,2,2]]





#USAR DESDE CUALQUIER LUGAR PARA REMAPEAR LOS BOTONES
func _maping_all(entradas,unique,joypad):#Array de inputs , si se usaran unicamente los botones del joypad, si se puede usar el joyderecho
	var input = entradas
	var joybutton = false
	if Input.get_connected_joypads().count(0)>=1:
		joybutton = true
	for i in input.size():
		var keyremap = input[i][2]
		var val = input[i][1]  # Código de la tecla
		var action = input[i][2]  # Acción a modificar
		var valbutton = input[i][3]  # Código de la boton en joy
		


		# Crear el evento de entrada con la tecla correspondiente


		var event = InputEventKey.new()
		event.scancode = val  

		# Eliminar eventos previos y agregar el nuevo mapeo
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)


		var ev = InputEventJoypadButton.new()
		ev.button_index = valbutton

		# Eliminar eventos previos y agregar el nuevo mapeo
		if unique == true:
			InputMap.action_erase_events(action)
		InputMap.action_add_event(action, ev)



	#AGREGAR EL JOYSTICK SI SE CONFIGURO 
		var xi = input[i][4]
		var xir = input[i][5]

		if xi != 0:
			var eve = InputEventJoypadMotion.new()
			var motion_event = null
			if xi == -1:
				motion_event = InputEventJoypadMotion.new()
				motion_event.axis = 0  
				motion_event.axis_value = -1.0  
				input[i][3] = -1
			elif xi == 2:
				motion_event = InputEventJoypadMotion.new()
				motion_event.axis = 1  
				motion_event.axis_value = 1.0  
				input[i][3] = 2
			elif xi == 1:
				motion_event = InputEventJoypadMotion.new()
				motion_event.axis = 0  
				motion_event.axis_value = 1.0  
				input[i][3] = 1
			elif xi == -2:
				motion_event = InputEventJoypadMotion.new()
				motion_event.axis = 1  
				motion_event.axis_value = -1.0  
				input[i][3] = -2

			# Si se creó un evento de movimiento, asignar el `device` y agregarlo
			if motion_event:
				motion_event.device = joypad
				if !InputMap.action_has_event(keyremap, motion_event):
					InputMap.action_add_event(keyremap, motion_event)

		if xir != 0:
			var eve = InputEventJoypadMotion.new()
			var motion_event = null
			if xi == -1:
				motion_event = InputEventJoypadMotion.new()
				motion_event.axis = 2  
				motion_event.axis_value = -1.0  
				input[i][4] = -1
			elif xi == 2:
				motion_event = InputEventJoypadMotion.new()
				motion_event.axis = 3  
				motion_event.axis_value = 1.0  
				input[i][4] = 2
			elif xi == 1:
				motion_event = InputEventJoypadMotion.new()
				motion_event.axis = 2  
				motion_event.axis_value = 1.0  
				input[i][4] = 1
			elif xi == -2:
				motion_event = InputEventJoypadMotion.new()
				motion_event.axis = 3  
				motion_event.axis_value = -1.0  
				input[i][4] = -2

			# Si se creó un evento de movimiento, asignar el `device` y agregarlo
			if motion_event:
				motion_event.device = joypad
				if !InputMap.action_has_event(keyremap, motion_event):
					InputMap.action_add_event(keyremap, motion_event)
