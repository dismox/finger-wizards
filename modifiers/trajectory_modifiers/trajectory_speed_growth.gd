extends TrajectoryModifier
class_name TrajectorySpeedGrowth

@export var max_boost: float = 100.0
@export var growth_rate: float = 0.5

func process(delta: float, bullet: Bullet) -> Vector2:
	var t = bullet.life_time
	var boost = max_boost * (1.0 - exp(-t * growth_rate))
	bullet.speed = bullet.speed + boost
	return Vector2.ZERO
