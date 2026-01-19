extends Enemy
class_name Sniper

func attack(dir: Vector2) -> void:
	await get_tree().create_timer(0.2).timeout
	shoot(dir)

func apply_damage(amount: float) -> void:
	Game.spawn_paddle(global_position, Game.Puddle_type.RED, Vector2(0.5, scale.x))
	super.apply_damage(amount)

func _set_state(new_state: State) -> void:
	super._set_state(new_state)
	if new_state == State.RETREAT and attack_timer < 0.0:
		attack_timer = 0.5
		radial_shoot(Vector2.ZERO, 4)

func radial_shoot(dir: Vector2, count: int) -> void:
	for point in shoot_points:
		Game.spawn_radial_bullets(
			bullet_scene,
			point.global_position,
			count,
			self,
			10.0,
			100.0,
			100.0,
			dir.angle(),
		)
