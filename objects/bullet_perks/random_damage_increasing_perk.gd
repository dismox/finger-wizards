extends BulletPerk
class_name RandomDamagezIncreasingPerk

var chanсe: float = 0.0

func on_shoot(hand, bullet: Bullet) -> void:
	if (chanсe + randf()) >= 1.0:
		bullet.damage += chanсe * 50
		chanсe = 0.0
	else:
		chanсe += 0.1
