extends Enemy
class_name RocketTrooper

func attack(dir: Vector2) -> void:
	shoot(dir)

func apply_damage(amount: float) -> void:
	Game.spawn_paddle(global_position, Game.Puddle_type.RED, Vector2(0.5, scale.x))
	super.apply_damage(amount)
