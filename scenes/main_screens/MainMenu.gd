extends "res://scenes/main_screens/GMenuScreen.gd"
#Signals
signal play_pressed
signal options_pressed
signal credits_pressed
signal notes_pressed

#Properties
onready var button_play : = $HorizontalContainer/VerticalContainer/CenterContainerPlay/Play
onready var text_notes : = $HorizontalContainer/MarginContarnerNotes/VBoxContainer/TextNotes
onready var button_notes : = $HorizontalContainer/MarginContarnerNotes/VBoxContainer/Notes

func _ready():
	first_focus = button_play
	pass 

func _on_Play_pressed():
	emit_signal("play_pressed")
	pass

func _on_Credits_pressed():
	emit_signal("credits_pressed")
	pass

func _on_Options_pressed():
	emit_signal("options_pressed")
	pass

func _on_Notes_pressed():
	if not button_notes.toggle_mode:
		emit_signal("notes_pressed")

func _on_Notes_toggled(button_pressed : bool):
	text_notes.visible = button_pressed
