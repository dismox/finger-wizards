extends BulletPerk
class_name FadeGravityPerk

@export var radius: float = 100.0
@export var strength: float = 50.0

func on_bullet_fade(hand, bullet: Bullet) -> void:
	Game._apply_gravity(bullet.global_position, radius, strength)
