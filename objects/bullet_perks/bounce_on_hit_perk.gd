extends BulletPerk
class_name BounceOnHitPerk

@export var max_bounces := 99
@export var damage_multiplier := 0.8

var bounce_count := {}

func on_bullet_hit(hand, bullet: Bullet, target: Entity) -> void:
	if not bounce_count.has(bullet):
		bounce_count[bullet] = 0

	if bounce_count[bullet] >= max_bounces:
		return

	bounce_count[bullet] += 1

	# Потеря урона
	bullet.damage *= damage_multiplier

	# Новый угол — случайный или по логике
	var new_dir := (bullet.global_position - target.global_position).normalized()
	bullet.rotation = new_dir.angle()

	# НЕ даём пуле умереть
	bullet.state = Bullet.BulletState.FLYING
	bullet.area.monitoring = true
	bullet.speed = abs(bullet.speed)
	bullet.cancel_hit = true
