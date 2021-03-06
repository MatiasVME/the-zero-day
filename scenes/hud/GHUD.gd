extends CanvasLayer

# Actor que esta asociado o utilizando el hud
var hud_actor : GActor

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

func add_actor_to_hud(actor : GActor):
	$AvatarHandler.add_avatar(actor)
	
func _on_player_dead(player):
	$Curtain.anim_dead()
	$Curtain.anim_end_lose()

	DataManager.save_all_data()
	
func _on_get_damage(player, damage):
	$Curtain.anim_hit()

func _on_win_adventure():
#	$AnimHotbar.play("hide")
#	$AnimBulletInfo.play("hide")
#	$AnimAvatarHandler.play("hide")
#	$AnimEndLevel.play("show")
	
#	var current_player = PlayerManager.get_current_player()
#	current_player.can_move = false
#	current_player.get_node("Anim").play("DanceOfVictory")
	
#	$GameMenu/Inventory.disabled = true
	pass

func _on_lose_adventure():
	print_debug("lost adventure??")

func _on_player_level_up(player):
#	$GameMenu/StatPanel.update_all()
	pass
	