extends Node2D

signal menu_button_unpressed

func _on_Config_toggled(button_pressed):
	if button_pressed:
		$Panels/Menu.show()
		$Panels/Inventory.hide()
		$Panels/Skills.hide()
		$Panels/PlayersInfo.hide()
		
		$InfoPlayers.pressed = false
		$Inventory.pressed = false
		$Skills.pressed = false
	else:
		$Panels/Menu.hide()
		$Panels/Inventory.hide()
		$Panels/Skills.hide()
		$Panels/PlayersInfo.hide()
		
		$Anim.play_backwards("show")
		emit_signal("menu_button_unpressed")

func _on_Inventory_toggled(button_pressed):
	if button_pressed:
		$Panels/Menu.hide()
		$Panels/Inventory.show()
		$Panels/Skills.hide()
		$Panels/PlayersInfo.hide()
		
		$InfoPlayers.pressed = false
		$Config.pressed = false
		$Skills.pressed = false
	else:
		$Panels/Menu.hide()
		$Panels/Inventory.hide()
		$Panels/Skills.hide()
		$Panels/PlayersInfo.hide()
		
		$Anim.play_backwards("show")
		emit_signal("menu_button_unpressed")

func _on_Skills_toggled(button_pressed):
	if button_pressed:
		$Panels/Menu.hide()
		$Panels/Inventory.hide()
		$Panels/Skills.show()
		$Panels/PlayersInfo.hide()
		
		$InfoPlayers.pressed = false
		$Config.pressed = false
		$Inventory.pressed = false
	else:
		$Panels/Menu.hide()
		$Panels/Inventory.hide()
		$Panels/Skills.hide()
		$Panels/PlayersInfo.hide()
		
		$Anim.play_backwards("show")
		emit_signal("menu_button_unpressed")

func _on_InfoPlayers_toggled(button_pressed):
	if button_pressed:
		$Panels/Menu.hide()
		$Panels/Inventory.hide()
		$Panels/Skills.hide()
		$Panels/PlayersInfo.show()
		
		$Skills.pressed = false
		$Config.pressed = false
		$Inventory.pressed = false
	else:
		$Panels/Menu.hide()
		$Panels/Inventory.hide()
		$Panels/Skills.hide()
		$Panels/PlayersInfo.hide()
		
		$Anim.play_backwards("show")
		emit_signal("menu_button_unpressed")