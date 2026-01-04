extends TrajectoryModifier
class_name TrajectorySpiral

@export var radius: float = 8.0
@export var angular_speed: float = 3.0   # обороты в секунду

func process(delta: float, bullet: Bullet) -> Vector2:
	var t = bullet.life_time * TAU * angular_speed
	var offset = Vector2(
		cos(t) * radius,
		sin(t) * radius
	)
	return offset.rotated(bullet.rotation)
