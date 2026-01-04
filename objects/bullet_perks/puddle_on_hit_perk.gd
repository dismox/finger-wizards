extends BulletPerk
class_name PuddleOnHitPerk

@export var puddle_scene: PackedScene

func on_bullet_hit(hand, bullet: Bullet, target) -> void:
	Game.spawn_paddle(bullet.global_position, bullet.puddle_type, Vector2(0.1, bullet.scale.x))
