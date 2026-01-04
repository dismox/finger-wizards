extends TrajectoryModifier
class_name TrajectorySpeedSine

@export var amplitude: float = 30.0
@export var frequency: float = 2.0

func process(delta: float, bullet: Bullet) -> Vector2:
	var base = bullet.speed
	var t = bullet.traveled_distance
	bullet.speed = base + sin(t * TAU * frequency) * amplitude / 2.0
	return Vector2.ZERO
