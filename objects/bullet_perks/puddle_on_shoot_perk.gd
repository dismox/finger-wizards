extends BulletPerk
class_name PuddleOnShootPerk

func on_shoot(hand, bullet: Bullet) -> void:
	Game.spawn_paddle(hand.global_position, bullet.puddle_type, Vector2(0.1, bullet.scale.x))
