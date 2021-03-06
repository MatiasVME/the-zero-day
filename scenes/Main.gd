extends Node2D

func _ready():
	$Camera.smoothing_speed = 15
	$Camera.global_position = global_position
	
	$Version.text = Main.VERSION
	
	if Main.ot_intro_music:
		Main.ot_intro_music = false
		MusicManager.play(MusicManager.Music.ATMOSFERIC_ACTION)

func _on_Back_pressed():
	$Camera.global_position = global_position

func _on_BackFromCredits_pressed():
	$Camera.global_position = global_position

func _on_DeleteData_pressed(commit: int):
	# Sistema de confirmacion agregado
	# Falta documentar y agregar sprites del gui

	var commit_windows = $Options/CommitDelete
	var button_back = $Options/Back
	var sound_manager = $Options/sonido
	var button_delete = $Options/DeleteData

	match commit:
		0:
			commit_windows.show()
			button_back.hide()
			button_delete.hide()
			sound_manager.hide()
		1:
			DataManager.remove_all_data()
			DataManager.init_again_data()
			commit_windows.hide()
			button_back.show()
			button_delete.show()
			sound_manager.show()
		2:
			commit_windows.hide()
			button_back.show()
			button_delete.show()
			sound_manager.show()

func _on_Credits_pressed():
	var credits_pos = $Credits.global_position
	credits_pos.x = credits_pos.x + Main.RES_X / 2
	credits_pos.y = credits_pos.y + Main.RES_Y / 2
	
	$Camera.global_position = credits_pos
	$Credits._resume()

func _on_Play_pressed():
#	$Camera.global_position = $AdventureMode.global_position
	$Camera/Anim.play("Enter")

func _on_Config_pressed():
	var option_pos = $Options.global_position
	option_pos.x = option_pos.x + Main.RES_X / 2
	option_pos.y = option_pos.y + Main.RES_Y / 2
	
	$Camera.global_position = option_pos

func _on_Version_pressed():
	var version_pos = $VersionNotes.global_position
	version_pos.x = version_pos.x + Main.RES_X / 2
	version_pos.y = version_pos.y + Main.RES_Y / 2
	
	$Camera.global_position = version_pos

func _on_Anim_animation_finished(anim_name):
	if anim_name == "Enter":
		get_tree().change_scene("res://scenes/main_screens/AdventureMode.tscn")
