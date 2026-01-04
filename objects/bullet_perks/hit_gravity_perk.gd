extends BulletPerk
class_name HitGravityPerk

@export var radius: float = 100.0
@export var strength: float = 50.0

func on_bullet_hit(hand, bullet: Bullet, target: Entity) -> void:
	radius = bullet.damage * 10.0
	strength = bullet.speed / 10.0
	Game._apply_gravity(bullet.global_position, radius, strength)
