"""
PlayerManager.gd

Gestiona las instancias de los players (GPlayer).
"""

extends Node

# Son los GPlayers que el jugador puede llegar a controlar
var players = []
# GPlayer actual
var current_player = get_current_player() setget , get_current_player
var name_of_available_players := [] setget , get_name_of_available_players

enum PlayerType {
	DORBOT,
	MATBOT,
	PIXBOT,
	SERBOT
}
var player_type = PlayerType.MATBOT # Cambiar a DORBOT mas adelante

var dorbot = preload("res://scenes/actors/players/dorbot/Dorbot.tscn")
#var matbot = preload("res://scenes/actors/players/matbot/Matbot.tscn")
#var pixbot = preload("res://scenes/actors/players/pixbot/Pixbot.tscn")
#var serbot = preload("res://scenes/actors/players/serbot/Serbot.tscn")

# Este es el player connectado, se usa esta variable
# para luego desconectarlo
var current_player_connected

signal player_changed(new_player)
signal player_shooting(player, direction)
signal player_reload(player)

signal player_gain_hp(player, amount)
signal player_get_damage(player, amount)
signal player_gain_xp(player, amount)
#signal player_level_up(player, new_level) # old
signal player_level_up(player)
signal player_dead(player)

# Inicia y retorna un player de los que estan creados en el
# DataManager.
func init_player(player_num : int) -> GPlayer:
	print_debug("Players: ", DataManager.players)
	if player_num > DataManager.players.size():
		return null
	
	var player
	
	# Por algun motivo que la humanidad desconoce hay que
	# castear eso a int :S
	match int(DataManager.players[player_num].player_type):
		PlayerType.DORBOT:
			player = dorbot.instance()
		PlayerType.MATBOT:
			player = load("res://scenes/actors/players/matbot/Matbot.tscn").instance()
		PlayerType.PIXBOT:
			player = load("res://scenes/actors/players/pixbot/Pixbot.tscn").instance()
		PlayerType.SERBOT:
			player = load("res://scenes/actors/players/serbot/Serbot.tscn").instance()
	
	# Buscar instancias no validas y las borra si las encuentra,
	# debe de hacer esto porque los GPlayers son borrados al salir
	# de escena. (si no estoy mal)
	#
	var i = 0
	while i < players.size():
		if not is_instance_valid(players[i]):
			players.remove(i)
	
	players.append(player)
#	print_debug(players)
	
	# Le asociamos la data del player con la data de juego
	player.data = DataManager.players[player_num]
	cad_players(player)
	
	if player.data.is_dead:
		player.data.revive()
	
	print_debug(player)
	return player

func get_name_of_available_players():
	var names := []
	
	for player in DataManager.players:
		names.append(player.character_name)
	
	return names

# Siempre hay que llamar a esta funcion antes de salir del
# juego!!
func clear_players():
	disconnect_player(current_player_connected)
	players.clear()
	print_debug("players.clear()", players)
	

# Conecta se??ales y desconecta se??ales si es que hay otro
# player
# Connect And Disconnect Players
func cad_players(_new_player : GPlayer, old_player = null):
	current_player_connected = _new_player
	
#	print("cad_players(): new_player: ", current_player_connected)
#	print("cad_players(): old_player: ", old_player)
	
	if not current_player_connected.is_connected("fire", self, "_on_player_fire"):
		connect_player(current_player_connected)
	
	if old_player and not old_player.is_connected("fire", self, "_on_player_fire"):
		disconnect_player(old_player)
	
func connect_player(player):
	player.connect("fire", self, "_on_player_fire", [player])
	player.connect("reload", self, "_on_player_reload", [player])
	
	player.data.connect("add_hp", self, "_on_add_hp", [player])
	player.data.connect("add_xp", self, "_on_add_xp", [player])
	player.data.connect("remove_hp", self, "_on_remove_hp", [player])
	player.data.connect("level_up", self, "_on_level_up", [player])
	player.data.connect("dead", self, "_on_dead", [player])
	
func disconnect_player(player):
	player.disconnect("fire", self, "_on_player_fire")
	player.disconnect("reload", self, "_on_player_reload")
	
	player.data.disconnect("add_hp", self, "_on_add_hp")
	player.data.disconnect("add_xp", self, "_on_add_xp")
	player.data.disconnect("remove_hp", self, "_on_remove_hp")
	player.data.disconnect("level_up", self, "_on_level_up")
	player.data.disconnect("dead", self, "_on_dead")

# Devuelve la instancia de el player actual (GPlayer)
func get_current_player():
	if players.size() > 0:
		return players[DataManager.get_current_player()]

func get_next_player():
	var next_player_num = DataManager.get_next_player()
	
	if next_player_num <= players.size() - 1:
		var next_player = players[next_player_num]
		cad_players(next_player, get_current_player())
		# Setea el proximo player como actual
		DataManager.set_next_player()
		emit_signal("player_changed", next_player)
	
		return next_player
	else:
		return get_current_player()

func _on_dead(player):
	emit_signal("player_dead", player)

func _on_player_fire(direction, player):
	emit_signal("player_shooting", player, direction)

func _on_player_reload(player):
	emit_signal("player_reload", player)

func _on_add_hp(amount, player):
	emit_signal("player_gain_hp", player, amount)
	
func _on_remove_hp(amount, player):
	emit_signal("player_get_damage", player, amount)

func _on_add_xp(amount, player):
	emit_signal("player_gain_xp", player, amount)

func _on_level_up(current_level, player):
	var stats = DataManager.get_stats(DataManager.get_current_player())
	stats.add_points(5)
	
	var player_data = DataManager.get_current_player_instance()
	# Se le a??ade el 10%
	var to_add = 10 * player_data.max_hp / 100 
	player_data.max_hp += clamp(to_add, 2, 1000)
	player_data.hp += clamp(to_add, 2, 1000)
	
	emit_signal("player_level_up", player)
