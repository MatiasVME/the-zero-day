extends Node2D

class_name GChest

# Cantidad de items que puede contener
export (int) var capacity := 0 
# Arreglo con la informacion de los item que contiene
var content := [] 
enum States {LOCKED, CLOSED, OPENED}
export (States) var state := States.CLOSED

signal chest_opened
signal chest_closed
signal chest_locked
signal chest_unlocked

#Función para agregar un TZDItem al cofre
func add_item(item_data : TZDItem) -> void:
	if content.size() < capacity:
		content.append(item_data)
		
#Retorna un TZDItem y lo elimina del Array content si existe
func drop_item(index : int = 0) -> TZDItem:
	var item : TZDItem = null
	if content.size() > abs(index):
		item = content[index]
		content.remove(index)
	return item
	
func is_empty() -> bool:
	return content.empty()
	
func is_full() -> bool:
	return content.size() == capacity
	

#Funciones temporales para tratar de encapsular comportamiento
#TODO:Analizar si son necesarias
func open_chest() -> void:
	if _change_state(States.OPENED):
		emit_signal("chest_opened")
	
func close_chest() -> void:
	if _change_state(States.CLOSED):
		emit_signal("chest_closed")
	
func lock_chest() -> void:
	if _change_state(States.LOCKED):
		emit_signal("chest_locked")
	
func unlock_chest() -> void:
	if _change_state(States.CLOSE):
		emit_signal("chest_unlocked")

#Función que debe sobreescribirse en las subclases
#representando los cambios de estado válidos
func _change_state(new_state : int) -> bool:
	return false