extends BulletPerk
class_name RandomStatsPerk

@export var puddle_scene: PackedScene

func on_shoot(hand, bullet: Bullet) -> void:
	bullet.damage = randf_range(bullet.damage * 0.5, bullet.damage * 2.0)
	bullet.range = randf_range(bullet.range * 0.5, bullet.range * 2.0)
	bullet.speed = randf_range(bullet.speed * 0.5, bullet.speed * 2.0)
