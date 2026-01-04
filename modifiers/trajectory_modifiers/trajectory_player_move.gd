extends TrajectoryModifier
class_name TrajectoryPlayerMove

var original_speed: float = -1.0

func process(delta: float, bullet: Bullet) -> Vector2:
	# Инициализация начальной скорости
	if original_speed < 0.0:
		original_speed = bullet.speed

	# Проверяем, есть ли у игрока скорость
	if not Game.player.has_method("get_velocity"):
		return Vector2.ZERO

	var vel = Game.player.get_velocity()

	if vel.length() < 15.0:
		# Полностью блокируем линейное движение
		# Возвращаем смещение обратно — снаряд остаётся на месте
		return -(Vector2.RIGHT.rotated(bullet.rotation) * original_speed * delta)
	else:
		# Пуля снова начинает двигаться с нормальной скоростью
		return Vector2.ZERO
