extends BulletPerk
class_name PushOnHitPerk

@export var force: float = 100.0

func on_bullet_hit(hand, bullet: Bullet, target) -> void:
	if not target is CharacterBody2D:
		return
	if target is Entity:
		var dir = (target.global_position - bullet.global_position).normalized()
		target.velocity += dir * bullet.damage * 15
