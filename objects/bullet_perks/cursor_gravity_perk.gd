extends BulletPerk
class_name CursorGravityPerk

@export var radius: float = 100.0
@export var strength: float = 10.0

func on_bullet_flight(hand, bullet: Bullet, delta: float) -> void:
	radius = bullet.damage * 10.0
	#strength = bullet.speed / 10.0
	Game._apply_gravity(hand.get_global_mouse_position(), radius, strength, delta)
