extends Node2D

func _ready():
	BuildManager.prepare_to_build(Enums.StructureType.CORE)
