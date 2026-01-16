extends Node2D



func _ready() -> void:
	Game.bullets_layer = $BulletsLayer
	Game.entities_layer = $EntitiesLayer
	Game.ui_layer = $"../UILayer"

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("spawn_enemies"):
		#Game.spawn_entity(load("res://objects/entities/enemies/skeleton/skeleton.tscn"), Vector2(randf()*20,randf()*20))
		Game.spawn_entity(load("res://objects/entities/enemies/slime/slime.tscn"), Vector2(randf()*20,randf()*20))
	if Input.is_action_pressed("upgrade"):
		Game.upgrade_choice()
