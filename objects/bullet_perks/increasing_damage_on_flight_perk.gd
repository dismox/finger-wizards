extends BulletPerk
class_name IncreasingDamageOnFlightPerk

@export var interval := 0.1
var acc := 0.0

func on_bullet_flight(hand, bullet: Bullet, delta: float) -> void:
	acc += delta
	if acc >= interval:
		acc = 0
		bullet.damage += 0.5
