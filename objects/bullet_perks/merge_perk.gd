extends BulletPerk
class_name MergePerk

@export var damage_add: float = 1.00       # множитель сложения
@export var range_add: float = 0.0
@export var speed_keep: bool = true       # скорость не суммируем
@export var scale_by_damage: bool = true

func on_bullet_hit(hand, bullet: Bullet, target) -> void:
	if not target is Bullet:
		return

	var other: Bullet = target

	# оба должны быть активны
	if bullet.state != Bullet.BulletState.FLYING:
		return
	if other.state != Bullet.BulletState.FLYING:
		return

	# чтобы не слиться дважды
	if bullet.get_instance_id() > other.get_instance_id():
		return

	_merge(bullet, other)


func _merge(a: Bullet, b: Bullet) -> void:
	# основной снаряд — a
	a.damage += b.damage * damage_add
	a.range += b.range * range_add

	# дальность — важно: не увеличивать пройденную
	a.traveled_distance = min(a.traveled_distance, a.range * 0.5)

	if not speed_keep:
		a.speed = max(a.speed, b.speed)

	if scale_by_damage:
		a.scale = Vector2.ONE * (a.damage / 10.0)

	# визуальный эффект
	if a.particle:
		a.particle.amount += b.particle.amount

	# аккуратно уничтожаем вторую пулю
	b.state = Bullet.BulletState.DEAD
	b.disable_interaction()
	b.queue_free()
