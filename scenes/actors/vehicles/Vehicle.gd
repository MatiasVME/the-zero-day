extends GActor

class_name Vehicle

export (int) var capacity = 1
export (int) var HP = 50
var drivers : Array = []

# Signals
signal mounted(who)
signal unmounted(who)
signal fulled
signal emptying

func mount(player : GPlayer) -> bool:
	if drivers.size() < capacity:
		drivers.append(player)
		emit_signal("mounted", player)
		
		if drivers.size() == capacity:
			emit_signal("fulled")
		
		return true
	return false
	
func leave(player : GPlayer):
	drivers.erase(player)
	emit_signal("unmounted", player)
	
	if drivers.size() < 1:
		emit_signal("emptying")
		
func has_driver() -> bool:
	return drivers.size() > 0
	
func get_driver() -> GPlayer:
	for i in drivers.size():
		if drivers[i] == PlayerManager.get_current_player():
			return drivers[i]
	return null