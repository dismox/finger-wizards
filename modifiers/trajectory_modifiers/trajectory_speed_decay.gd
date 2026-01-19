extends TrajectoryModifier
class_name TrajectorySpeedDecay

@export var start_boost: float = 200.0  # сколько добавить в начале
@export var decay_rate: float = 5.0     # скорость затухания

func process(delta: float, bullet: Bullet) -> Vector2:
	var t = bullet.life_time
	bullet.speed = 30.0 + bullet.speed * 2.1 * exp(-t * decay_rate)
	return Vector2.ZERO
