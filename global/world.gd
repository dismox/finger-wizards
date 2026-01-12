extends Node2D

var current_upgrade = null

func _ready() -> void:
	Game.bullets_layer = $BulletsLayer
	Game.entities_layer = $EntitiesLayer
	Game.ui_layer = $"../UILayer"

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("spawn_enemies"):
		Game.spawn_entity(load("res://objects/entities/enemies/slime/slime.tscn"), Vector2(randf()*10,randf()*10))
	if Input.is_action_pressed("upgrade"):
		if current_upgrade == null:
			var scene: PackedScene = load("res://global/upgrades_choise.tscn")
			current_upgrade = scene.instantiate()
			Game.ui_layer.add_child(current_upgrade)
		else:
			current_upgrade.queue_free()
