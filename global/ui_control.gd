extends Control

func _ready() -> void:
	Game.player.health_changed.connect(_on_health_changed)
	Game.player.mana_changed.connect(_on_mana_changed)
	
func _on_health_changed(entity: Entity, value: float):
	%HealthBar.value = value

func _on_mana_changed(value: float):
	%Manabar.value = value
