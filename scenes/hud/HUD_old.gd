extends CanvasLayer

var hud_actor

func _ready():
	PlayerManager.connect("player_dead", self, "_on_player_dead")
	PlayerManager.connect("player_get_damage", self, "_on_get_damage")
	PlayerManager.connect("player_level_up", self, "_on_player_level_up")
	
	Main.connect("win_adventure", self, "_on_win_adventure")
	Main.connect("lose_adventure", self, "_on_lose_adventure")
	
func _on_Inventory_toggled(button_pressed):
	if button_pressed:
		$AnimInv.play("show")
		$AnimAvatarHandler.play("hide")
		$Inventory.is_inventory_open = true
	else:
		$AnimInv.play("hide")
		$AnimAvatarHandler.play("show")
		$Inventory.is_inventory_open = false

# Establece un actor al HUD, para que se conecten las
# señales necesarias relacionadas con el HUD y los nodos
# mas internos.
func set_hud_actor(actor : GActor):
	hud_actor = actor
	
	$Hotbar.set_hotbar_actor(actor)
	$AvatarHandler.select_avatar(actor)
	
	$AnimHotbar.play("show")

func add_actor_to_hud(actor : GActor):
	$AvatarHandler.add_avatar(actor)
	
func _on_player_dead(player):
	$CurtainAnim.play("dead")
	
#	$AnimInv.play("hide")
#	$AnimGameMenu.play("hide")
	$AnimHotbar.play("hide")
	$AnimBulletInfo.play("hide")
	$AnimAvatarHandler.play("hide")
	$GameMenu/Inventory.disabled = true
	
	DataManager.save_all_data()
	
func _on_get_damage(player, damage):
	$CurtainAnim.play("hit")

func _on_Menu_toggled(button_pressed):
	if button_pressed:
		$AnimGameMenu.play("show_game_menu")
	else:
		$AnimGameMenu.play("hide_game_menu")

func _on_win_adventure():
	$AnimHotbar.play("hide")
	$AnimBulletInfo.play("hide")
	$AnimAvatarHandler.play("hide")
	$AnimEndLevel.play("show")
	
	var current_player = PlayerManager.get_current_player()
	current_player.can_move = false
	current_player.get_node("Anim").play("DanceOfVictory")
	
	$GameMenu/Inventory.disabled = true

func _on_Stats_toggled(button_pressed):
	if button_pressed:
		$AnimStatsPanel.play("show")
		$AnimBulletInfo.play("hide")
	else:
		$AnimStatsPanel.play("hide")
		$AnimBulletInfo.play("show")

func _on_player_level_up(player):
	$GameMenu/StatPanel.update_all()

func _on_Build_toggled(button_pressed):
	if button_pressed:
		$AnimBuildPanel.play("show")
	else:
		$AnimBuildPanel.play("hide")
