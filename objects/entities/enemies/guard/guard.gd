extends Enemy
class_name Guard

func attack(dir: Vector2) -> void:
	shoot(dir)
	retreat_range = randf_range(10.0, 200.0)
	attack_range = randf_range(retreat_range + 10.0, 300.0)
	#super.attack(dir)

func apply_damage(amount: float) -> void:
	Game.spawn_paddle(global_position, Game.Puddle_type.RED, Vector2(0.5, scale.x))
	super.apply_damage(amount)
