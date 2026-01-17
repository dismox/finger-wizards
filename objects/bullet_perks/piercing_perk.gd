extends BulletPerk
class_name PiercingPerk

@export var pierce_count: int = 99
@export var damage_multiplier: float = 0.8

var hit_counter := {}

func on_bullet_hit(hand, bullet: Bullet, target) -> void:
	if not hit_counter .has(bullet):
		hit_counter [bullet] = 0

	if hit_counter [bullet] >= pierce_count:
		return

	hit_counter [bullet] += 1

	# Потеря урона
	bullet.damage = bullet.damage * damage_multiplier

	# Новый угол — случайный или по логике
	#var new_dir := (bullet.global_position - target.global_position).normalized()
	#bullet.rotation = new_dir.angle()

	# НЕ даём пуле умереть
	bullet.state = Bullet.BulletState.FLYING
	bullet.area.monitoring = true
	bullet.speed = abs(bullet.speed)
	bullet.cancel_hit = true
