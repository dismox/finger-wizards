extends Enemy
class_name Trooper

func attack(dir: Vector2) -> void:
	for i in range(5):
		shoot(dir)
		await get_tree().create_timer(0.1).timeout
	attack_range = randf_range(100.0, 300.0)
	#super.attack(dir)

func apply_damage(amount: float) -> void:
	Game.spawn_paddle(global_position, Game.Puddle_type.RED, Vector2(0.5, scale.x))
	super.apply_damage(amount)
