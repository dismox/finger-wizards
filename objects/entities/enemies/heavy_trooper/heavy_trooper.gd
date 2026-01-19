extends Enemy
class_name HeavyTrooper

func attack(dir: Vector2) -> void:
	shoot(dir)
	#attack_range = randf_range(100.0, 300.0)
	#super.attack(dir)

func apply_damage(amount: float) -> void:
	Game.spawn_paddle(global_position, Game.Puddle_type.RED, Vector2(0.5, scale.x))
	super.apply_damage(amount)
