extends Resource
class_name BulletPerk

func on_shoot(hand, bullet: Bullet) -> void: pass

func on_bullet_hit(hand, bullet: Bullet, target) -> void: pass

func on_bullet_fade(hand, bullet: Bullet) -> void: pass

func on_bullet_flight(hand, bullet: Bullet, delta: float) -> void: pass
