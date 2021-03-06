extends Node2D

enum ObjectiveStatus {HIDE, IDLE, COMPLETED}
export (ObjectiveStatus) var objective_status = ObjectiveStatus.IDLE

# Numero total de jugadores que deben llegar
# al objetivo
export (int) var player_in_objetive := 1
var current_players_in_objetive := 0

export (bool) var is_final_objective := false
export (bool) var is_optional_objective := false

var idle_objective = preload("res://scenes/structures/objective/IdleObjective.png")
var player_inside = preload("res://scenes/structures/objective/PlayerInsideObjective.png")
var completed_objective = preload("res://scenes/structures/objective/CompletedObjective.png")

onready var objectives = get_tree().get_nodes_in_group("Objective")

func have_you_won():
	var objectives_to_won = objectives.size()
	var current_objectives = 0
	
	var i := 0
	while (i < objectives_to_won):
		if objectives[i].is_optional_objective:
			objectives_to_won -= 1
		elif objectives[i].objective_status == ObjectiveStatus.COMPLETED:
			current_objectives += 1
		
		i += 1
		
	if current_objectives == objectives_to_won:
		return true
		
	return false
	
func _on_EnterArea_body_entered(body):
	if body is GPlayer:
		current_players_in_objetive += 1
		
		if current_players_in_objetive >= player_in_objetive:
			objective_status = ObjectiveStatus.COMPLETED
		
		$Sprite.texture = player_inside
		
		if have_you_won():
			var hud = get_tree().get_nodes_in_group("HUD")
			
			if hud.size() > 0:
				hud = hud[0]
				get_tree().paused = true
				hud.get_node("Curtain").anim_end_win()
				
#			Main.win_adventure()
		else:
			$In.play()

func _on_EnterArea_body_exited(body):
	if body is GPlayer:
		current_players_in_objetive -= 1
		
		if objective_status == ObjectiveStatus.COMPLETED:
			$Sprite.texture = completed_objective
		else:
			$Sprite.texture = idle_objective
		
		$Out.play()
	