extends BulletPerk
class_name PuddleOnFlightPerk

@export var interval := 0.2
var acc := 0.0

func on_bullet_flight(hand, bullet: Bullet, delta: float) -> void:
	acc += delta
	if acc >= interval:
		acc = 0
		Game.spawn_paddle(bullet.global_position, bullet.puddle_type, Vector2(0.1, bullet.scale.x))
		#Game.spawn_snow(bullet.global_position)
