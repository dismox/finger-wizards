extends BulletPerk
class_name RandomMultishotPerk

var chanсe: float = 0.0

func on_shoot(hand, bullet: Bullet) -> void:
	if (chanсe + randf()) >= 1.0:
		#hand.multishot += chanсe * 10
		#bullet.damage += chanсe * 50
		#hand.shoot()
		#hand.multishot -= chanсe * 10
		chanсe = 0.0
	else:
		chanсe += 0.1
