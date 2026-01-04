extends TrajectoryModifier
class_name TrajectorySine

@export var amplitude: float = 5.0
@export var frequency: float = 10.0

func process(delta: float, bullet: Bullet) -> Vector2:
	var t = bullet.life_time
	var offset = Vector2(
		0,
		sin(t * frequency) * amplitude
	)
	return offset.rotated(bullet.rotation)
